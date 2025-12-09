import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController {
    
    private var splashVC: SplashViewController?
    
    private var dataCheckTimer: Timer?
    
    private var mainImageView: WKWebView?

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
        
    private func showSplashScreen() {
        let splash = SplashViewController()
        
        addChild(splash)
        splash.view.frame = view.bounds
        view.addSubview(splash.view)
        splash.didMove(toParent: self)
        
        self.splashVC = splash
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
            
            self.loadMainContent()
        })
    }
        
    private func startDataCheckTimer() {
        dataCheckTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkForData), userInfo: nil, repeats: true)
        RunLoop.current.add(dataCheckTimer!, forMode: .common)
    }
    
    @objc private func checkForData() {
        let finalURL = MainHelper.shared.finalDataImageURLString
        
        if finalURL != nil {
            dismissSplashScreen()
        }
    }
        
    private func loadMainContent() {
        let finalDataImageURLString = MainHelper.shared.finalDataImageURLString ?? ""
            
        if finalDataImageURLString.isEmpty {
            view.backgroundColor = .white
            return
        }
            
        guard let finalDataImageURL = URL(string: finalDataImageURLString) else { return }

        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
            
        let mainImageView = WKWebView(frame: .zero, configuration: config)
        self.mainImageView = mainImageView
            
        let customUserAgent = "Version/17.2 Mobile/15E148 Safari/604.1" // test111 в константы
        mainImageView.customUserAgent = customUserAgent
            
        view.addSubview(mainImageView)
            
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
            
        let request = URLRequest(url: finalDataImageURL)
        mainImageView.load(request)
    }
}
