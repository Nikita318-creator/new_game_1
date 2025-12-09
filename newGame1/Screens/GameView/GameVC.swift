import UIKit
import SnapKit

class GameVC: UIViewController {
   
    private enum Const {
        static let bacgraundImagename = "mainBackGraund"
        
        static let UserAgreementTitle = "UserAgreement".localized()
        static let StoreTitle = "Store".localized()
        static let RulesTitle = "Rules".localized()
        static let GraphTitle = "Graph".localized()
        static let gameButtonTitle = "GameButtonTitle".localized()
        
        static let needShowNotificationKey = "isNeedShowNotification"
        static let notificationTextKey = "notificationText"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: Const.bacgraundImagename)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLastVisitdayInfo() // вызываю тут чтоб поверх всех кнопок было
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.subviews.forEach {
            if $0 is MainButton {
                $0.removeFromSuperview()
            }
        }
        setupButtons()
    }
    
    private func setupButtons() {
        // MARK: - Создание кнопки для перехода на следующий экран
        let mainButton = MainButton(color: .textColor, title: Const.gameButtonTitle, font: .headlineFont, isActive: true)
        mainButton.setTitle(Const.gameButtonTitle, for: .normal)
        mainButton.addTarget(self, action: #selector(navigateToNextScreen), for: .touchUpInside)
        view.addSubview(mainButton)

        mainButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-200) // Позиция по оси Y смещена на 200 пунктов вниз от центра
            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
            make.height.equalTo(60)
        }
        
        // MARK: - Создание кнопки для перехода на storeButton экран
        let storeButton = MainButton(color: .textColor, title: Const.gameButtonTitle, font: .headlineFont, isActive: true)
        storeButton.setTitle(Const.StoreTitle, for: .normal)
        storeButton.addTarget(self, action: #selector(navigateToStoreScreen), for: .touchUpInside)
        view.addSubview(storeButton)

        storeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainButton.snp.bottom).offset(40)
            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
            make.height.equalTo(60)
        }
        
        // MARK: - Создание кнопки для перехода на graphButton экран
//        let graphButton = MainButton(color: .textColor, title: Const.GraphTitle, font: .headlineFont, isActive: true)
//        graphButton.setTitle(Const.GraphTitle, for: .normal)
//        graphButton.addTarget(self, action: #selector(navigateToGraphScreen), for: .touchUpInside)
//        view.addSubview(graphButton)

//        graphButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(storeButton.snp.bottom).offset(40)
//            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
//            make.height.equalTo(60)
//        }
        
        // MARK: - Создание кнопки для перехода на rulesButton экран
        let rulesButton = MainButton(color: .textColor, title: Const.RulesTitle, font: .headlineFont, isActive: true)
        rulesButton.setTitle(Const.RulesTitle, for: .normal)
        rulesButton.addTarget(self, action: #selector(navigateToRulesScreen), for: .touchUpInside)
        view.addSubview(rulesButton)

        rulesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(storeButton.snp.bottom).offset(40)
            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
            make.height.equalTo(60)
        }
        
        // MARK: - Создание кнопки для перехода на agreementButton экран
        let agreementButton = MainButton(color: .textColor, title: Const.UserAgreementTitle, font: .headlineFont, isActive: true)
        agreementButton.setTitle(Const.UserAgreementTitle, for: .normal)
        agreementButton.addTarget(self, action: #selector(navigateToAgreementScreen), for: .touchUpInside)
        view.addSubview(agreementButton)

        agreementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rulesButton.snp.bottom).offset(40)
            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
            make.height.equalTo(60)
        }
        
        view.layoutIfNeeded()
        
        // Добавьте эффект плавания для каждой кнопки с разными задержками или скоростями
        addFloatingEffect(to: mainButton, delay: 0.0, duration: 2.0)
        addFloatingEffect(to: storeButton, delay: 0.0, duration: 2.5)
//        addFloatingEffect(to: graphButton, delay: 0.0, duration: 3.0)
        addFloatingEffect(to: rulesButton, delay: 0.0, duration: 3.5)
        addFloatingEffect(to: agreementButton, delay: 0.0, duration: 4.0)
    }
    
    private func addFloatingEffect(to button: UIButton, delay: TimeInterval, duration: TimeInterval) {
        let floatAnimation = CABasicAnimation(keyPath: "position")
        floatAnimation.beginTime = CACurrentMediaTime() + delay
        floatAnimation.duration = duration
        floatAnimation.repeatCount = .infinity
        floatAnimation.autoreverses = true
        floatAnimation.fromValue = NSValue(cgPoint: CGPoint(x: button.center.x - 5, y: button.center.y - 5))
        floatAnimation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x + 5, y: button.center.y + 5))
        button.layer.add(floatAnimation, forKey: "floatAnimation")
    }
    
    @objc func navigateToNextScreen() {
        let mainScreenVC = MainScreenVC()
        self.navigationController?.pushViewController(mainScreenVC, animated: true)
    }
    
    @objc func navigateToStoreScreen() {
        let storeScreenVC = StoreScreenVC()
        self.navigationController?.pushViewController(storeScreenVC, animated: true)
    }
    
    @objc func navigateToGraphScreen() {
        let graphScreenVC = GraphScreenVC()
        self.navigationController?.pushViewController(graphScreenVC, animated: true)
    }
    
    @objc func navigateToAgreementScreen() {
        let agreementScreenVC = AgreementScreenVC()
        self.navigationController?.pushViewController(agreementScreenVC, animated: true)
    }
    
    @objc func navigateToRulesScreen() {
        let rulesScreenVC = RulesScreenVC()
        self.navigationController?.pushViewController(rulesScreenVC, animated: true)
    }
    
    // MARK: - Firebase
    
    private func fetchNotificationSetting() {
        // Ссылка на узел в базе данных
//        let needShowNotificationRef = databaseRef.child(Const.needShowNotificationKey)
//
//        // Получение значения
//        needShowNotificationRef.observeSingleEvent(of: .value) { snapshot in
//            if let value = snapshot.value as? Bool {
//                // Значение успешно получено
//                print("needShowNotification: \(value)")
//
//                // Вы можете использовать это значение для планирования уведомлений
//                if value {
//                    self.scheduleLocalNotification()
//                } else {
//                    print("don't show notification from Firebase")
//                }
//            } else {
//                print("No value found or value is not a Boolean")
//            }
//        } withCancel: { error in
//            print("Error fetching data: \(error.localizedDescription)")
//        }
    }

    private func scheduleLocalNotification() {
//        let needShowNotificationRef = databaseRef.child(Const.notificationTextKey)
//
//        // Получение значения
//        needShowNotificationRef.observeSingleEvent(of: .value) { snapshot in
//            if let value = snapshot.value as? String {
//                let alert = UIAlertController(title: nil, message: value, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    private func updateLastVisitdayInfo() {
        let specialCoinsGotCount = CoinsHelper.shared.updateSpecialCoins()
        if specialCoinsGotCount > 0 {
            let lastVisitDateView = LastVisitDateView()
            lastVisitDateView.didTapOkHandler = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    CoinsHelper.shared.saveSpecialCoins(CoinsHelper.shared.getSpecialCoins() + specialCoinsGotCount)
                }
            }
            view.addSubview(lastVisitDateView)
            lastVisitDateView.snp.makeConstraints { make in
                // Центрируем по горизонтали и устанавливаем фиксированную высоту
                make.centerX.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20) // Расстояние от верхней части экрана
                make.height.equalTo(400) // Установите высоту в зависимости от вашего дизайна
                make.width.equalToSuperview().inset(40) // Устанавливаем ширину с отступом от краев экрана
            }
            view.layoutIfNeeded()
            
            lastVisitDateView.updateView(forStreak: specialCoinsGotCount) // Обновит представление для -х дней подряд
        }
    }
}
