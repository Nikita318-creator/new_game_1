import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let configService = ConfigDataService()
        Task {
            let coreData = await configService.collectCoreData()
            // Проводим регистрацию в RTDB
            DatabaseService().registerUser(data: coreData)
        }
    }
}
