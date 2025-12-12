import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var splashVC: SplashViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gameVC = GameVC()
        let navigationController = UINavigationController(rootViewController: gameVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false)
    }
}
