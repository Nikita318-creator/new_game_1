import UIKit
import SnapKit

class GameVC: UIViewController {
   
    private enum Const {
        static let bacgraundImagename = "mainBackGraund"
        
        static let UserAgreementTitle = "UserAgreement".localized()
        static let StoreTitle = "Store".localized()
        static let gameButtonTitle = "GameButtonTitle".localized()
        static let profileButtonTitle = "Profile"
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
            make.centerY.equalToSuperview().offset(-200)
            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
            make.height.equalTo(60)
        }
        
        // MARK: - Создание кнопки для перехода на следующий экран
//        let profileButton = MainButton(color: .textColor, title: Const.profileButtonTitle, font: .headlineFont, isActive: true)
//        profileButton.setTitle(Const.profileButtonTitle, for: .normal)
//        profileButton.addTarget(self, action: #selector(navigateToProfileScreenVC), for: .touchUpInside)
//        view.addSubview(profileButton)
//
//        profileButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(mainButton.snp.bottom).offset(40)
//            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
//            make.height.equalTo(60)
//        }
        
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
        
        // MARK: - Создание кнопки для перехода на agreementButton экран
        let agreementButton = MainButton(color: .textColor, title: Const.UserAgreementTitle, font: .headlineFont, isActive: true)
        agreementButton.setTitle(Const.UserAgreementTitle, for: .normal)
        agreementButton.addTarget(self, action: #selector(navigateToAgreementScreen), for: .touchUpInside)
        view.addSubview(agreementButton)

        agreementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(storeButton.snp.bottom).offset(40)
            make.width.equalTo(2 * UIScreen.main.bounds.width / 3)
            make.height.equalTo(60)
        }
        
        view.layoutIfNeeded()
        
        addFloatingEffect(to: mainButton, delay: 0.0, duration: 2.0)
        addFloatingEffect(to: mainButton, delay: 0.0, duration: 2.0)
        addFloatingEffect(to: storeButton, delay: 0.0, duration: 2.5)
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
    
    @objc func navigateToProfileScreenVC() {
        let mainScreenVC = ProfileScreenVC()
        self.navigationController?.pushViewController(mainScreenVC, animated: true)
    }
    
    @objc func navigateToStoreScreen() {
        let storeScreenVC = StoreScreenVC()
        self.navigationController?.pushViewController(storeScreenVC, animated: true)
    }

    @objc func navigateToAgreementScreen() {
        UIApplication.shared.open(URL(string: "https://sites.google.com/view/agreementmain")!)
    }
}
