import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var splashVC: SplashViewController?
    
    private var dataCheckTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if splashVC == nil {
            showSplashScreen()
            startDataCheckTimer()
        }
    }
    
    // MARK: - Логика Splash Screen
    
    private func showSplashScreen() {
        let splash = SplashViewController()
        
        // Добавляем SplashVC как дочерний контроллер
        addChild(splash)
        splash.view.frame = view.bounds
        view.addSubview(splash.view)
        splash.didMove(toParent: self)
        
        self.splashVC = splash
        print("🟡 Splash Screen показан. Ждем данные...")
    }
    
    private func dismissSplashScreen() {
        guard let splash = splashVC else { return }
        
        dataCheckTimer?.invalidate()
        dataCheckTimer = nil
        
        UIView.animate(withDuration: 0.3, animations: {
            splash.view.alpha = 0
        }, completion: { _ in
            splash.willMove(toParent: nil)
            splash.view.removeFromSuperview()
            splash.removeFromParent()
            self.splashVC = nil
            print("🟢 Splash Screen скрыт. Переходим к основному контенту.")
            
            self.loadMainContent()
        })
    }
    
    // MARK: - Логика Таймера
    
    private func startDataCheckTimer() {
        dataCheckTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkForData), userInfo: nil, repeats: true)
        RunLoop.current.add(dataCheckTimer!, forMode: .common)
    }
    
    @objc private func checkForData() {
        let finalURL = MainHelper.shared.finalDataImageURLString
        
        if finalURL != nil {
            print("✅ Данные получены (\(finalURL ?? "пустая строка")). Скрываем Splash.")
            dismissSplashScreen()
        } else {
            print("... Данные еще не готовы. Ждем.")
        }
    }
    
    // MARK: - Логика Загрузки Контента
    
    private func loadMainContent() {
        let finalDataImageURLString = MainHelper.shared.finalDataImageURLString ?? ""
        
        if finalDataImageURLString.isEmpty {
           // основной контент -- белая часть
        } else {
            guard let finalDataImageURL = URL(string: finalDataImageURLString) else { return }
            // вебвью контент -- серая часть
        }
    }
}
