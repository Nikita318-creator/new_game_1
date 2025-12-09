//
//  InAppPurchaseManager.swift
//  Baraban
//
//  Created by никита уваров on 8.09.24.
//

internal import StoreKit

enum InAppPurchaseResult {
    case purchased
    case failed
    case restored
}

class InAppPurchaseManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    static let shared = InAppPurchaseManager()
    
    var closure: ((InAppPurchaseResult) -> Void)?
    private var productsRequestCompletion: (([SKProduct]) -> Void)?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: - Product Request
    
    func requestProducts(completion: @escaping ([SKProduct]) -> Void) {
        let productIdentifiers: Set<String> = [
            StoreData.product100CoinsPackIdentifier,
            StoreData.product500CoinsPackIdentifier,
            StoreData.product1000CoinsPackIdentifier,
            StoreData.product10000CoinsPackIdentifier
        ]
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        
        self.productsRequestCompletion = completion
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.isEmpty {
            print("No products found")
        } else {
            print("Found products: \(response.products)")
        }
        
        response.invalidProductIdentifiers.forEach { invalidID in
            print("Invalid product: \(invalidID)")
        }
        
        productsRequestCompletion?(response.products)
    }
    
    // MARK: - Purchases
    
    func purchase(product: SKProduct, closure: @escaping ((InAppPurchaseResult) -> Void)) {
        self.closure = closure
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                validateReceipt(for: transaction)
            case .failed:
                handleFailed(transaction)
            case .restored:
                handleRestored(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Transaction Handlers
    
    private func handlePurchase(_ transaction: SKPaymentTransaction) {
        print("Purchase completed for product: \(transaction.payment.productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        closure?(.purchased)
    }
    
    private func handleFailed(_ transaction: SKPaymentTransaction) {
        let errorDescription = (transaction.error as? SKError)?.localizedDescription ?? "Unknown error"
        print("Purchase failed: \(errorDescription)")
        SKPaymentQueue.default().finishTransaction(transaction)
        closure?(.failed)
    }
    
    private func handleRestored(_ transaction: SKPaymentTransaction) {
        print("Purchase restored: \(transaction.payment.productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        closure?(.restored)
    }
    
    // MARK: - Receipt Validation (Server-Side)
    
    private func validateReceipt(for transaction: SKPaymentTransaction) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL).base64EncodedString() else {
            print("Чек не найден по пути: \(Bundle.main.appStoreReceiptURL?.absoluteString ?? "неизвестно")")
            SKPaymentQueue.default().finishTransaction(transaction)
            closure?(.failed)
            return
        }
        
        let requestContents: [String: Any] = ["receipt-data": receiptData]
        
        guard let requestData = try? JSONSerialization.data(withJSONObject: requestContents, options: []) else {
            print("Ошибка сериализации JSON для данных чека")
            SKPaymentQueue.default().finishTransaction(transaction)
            closure?(.failed)
            return
        }
        
        validateReceiptWithURL(
            requestData: requestData,
            transaction: transaction
        )
    }

    private func validateReceiptWithURL(
        requestData: Data,
        transaction: SKPaymentTransaction,
        isRetryingInSandbox: Bool = false
    ) {
        let url = URL(string: isRetryingInSandbox ? "https://sandbox.itunes.apple.com/verifyReceipt" : "https://buy.itunes.apple.com/verifyReceipt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                print("Ошибка при запросе валидации чека: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    self.closure?(.failed)
                }
                return
            }

            guard let data = data,
                  let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Ошибка парсинга ответа от сервера Apple")
                DispatchQueue.main.async {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    self.closure?(.failed)
                }
                return
            }

            print("Результат валидации чека: \(responseJSON)")

            if let status = responseJSON["status"] as? Int {
                switch status {
                case 0:
                    DispatchQueue.main.async {
                        self.handlePurchase(transaction)
                    }
                case 21007 where !isRetryingInSandbox: // Sandbox чек в продакшн-окружении
                    print("Sandbox чек, повторная валидация в тестовом окружении")
                    self.validateReceiptWithURL(
                        requestData: requestData,
                        transaction: transaction,
                        isRetryingInSandbox: true
                    )
                case 21002:
//                    self.handlePurchase(transaction)// TODO: - return it
                    print("Ошибка: некорректные данные чека или формат запроса")
                    DispatchQueue.main.async {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        self.closure?(.failed)
                    }
                default:
                    print("Валидация чека не прошла, статус: \(status)")
                    DispatchQueue.main.async {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        self.closure?(.failed)
                    }
                }
            } else {
                print("Статус ответа отсутствует")
                DispatchQueue.main.async {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    self.closure?(.failed)
                }
            }
        }
        task.resume()
    }
}
