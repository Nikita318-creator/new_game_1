import UIKit
import SnapKit

class LevelcomplitedView: UIView {
    
    var okDidTapHandler: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Levelcomplited.Title".localized()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.FontsName.simpleFont.value.withSize(36)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Levelcomplited.Description".localized()
        label.font = UIFont.FontsName.simpleFont.value.withSize(26)
        label.textColor = .black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) // Кастомный серый цвет
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 34)
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let scoreView = ScoreView() // Initialize ScoreView
    
    func setup(time: TimeInterval, errors: Int) {
        // Устанавливаем градиентный фон
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.lightGray.cgColor] // Светлый градиент
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Создаем stackView для заголовка и описания
        let contentStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .center
        
        // Создаем stackView для всего контента
        let mainStackView = UIStackView(arrangedSubviews: [contentStackView, scoreView, okButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        
        addSubview(mainStackView)
        
        // Устанавливаем ограничения для основного stackView
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60) // Отступ сверху
            make.bottom.equalToSuperview().inset(20) // Отступ снизу
        }
        
        // Устанавливаем ограничения для кнопки
        okButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(70)
        }
        
        // Устанавливаем ограничения для ScoreView
        scoreView.snp.makeConstraints { make in
            make.width.equalToSuperview()//.multipliedBy(0.8) // Adjust width as needed
            make.height.equalTo(150) // Adjust height as needed
        }
        
        scoreView.setupLabels(
            time: time,
            errors: errors
        )
    }
    
    @objc private func okButtonTapped() {
        okDidTapHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Обновляем кадр градиентного слоя при изменении размеров представления
        if let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
}
