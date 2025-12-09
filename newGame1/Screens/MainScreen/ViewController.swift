import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController {
    
    private var splashVC: SplashViewController?
    
    private var dataCheckTimer: Timer?
    
    private var mainImageView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
        
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
        
        config.mediaTypesRequiringUserActionForPlayback = []
        
        config.allowsInlineMediaPlayback = true
            
        let mainImageView = WKWebView(frame: .zero, configuration: config)
        self.mainImageView = mainImageView
        
        mainImageView.navigationDelegate = self
        mainImageView.uiDelegate = self
            
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

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let scheme = (url.scheme ?? "").lowercased()
            
            let internalSchemes: Set<String> = ["http", "https", "about", "srcdoc", "blob", "data", "javascript", "file"]
            
            if internalSchemes.contains(scheme) {
                decisionHandler(.allow)
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}

extension ViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = defaultText
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let text = alert.textFields?.first?.text
            completionHandler(text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        
        decisionHandler(.grant)
    }
    
    func webView(_ webView: WKWebView, requestDeviceOrientationAndMotionPermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        
        decisionHandler(.grant)
    }
}
