import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground // Светлый или темный фон
        
        // 1. Создаем UIImageView
        let imageView = UIImageView(image: UIImage(systemName: "hand.wave.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue // Цвет иконки
        imageView.contentMode = .scaleAspectFit
        
        // 2. Добавляем иконку на главный View
        view.addSubview(imageView)
        
        // 3. Констрейнты (Центрирование)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
