import UIKit
import SnapKit

class ChapterCell: UICollectionViewCell, Cofigurable {
    
    // Лейбл для текста
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        // Оставим ваш шрифт, но уменьшим размер, чтобы избежать перекрытия
        label.font = UIFont(name: "AvenirNext-Bold", size: 36) // Снижен с 74 до 36
        label.textAlignment = .center
        label.numberOfLines = 1 // Ограничиваем, чтобы не нарушать разметку
        label.adjustsFontSizeToFitWidth = true // Добавляем, чтобы текст умещался
        return label
    }()
    
    // Градиентный слой (делаем его более ярким и современным)
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        // Яркий, современный градиент
        let colorA = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8).cgColor // Почти черный, прозрачный
        let colorB = UIColor(red: 0.5, green: 0.3, blue: 0.9, alpha: 0.8).cgColor // Фиолетовый
        gradient.colors = [colorA, colorB]
        gradient.startPoint = CGPoint(x: 0, y: 0) // Верхний левый угол
        gradient.endPoint = CGPoint(x: 1, y: 1) // Нижний правый угол (диагональ)
        return gradient
    }()
    
    private let starImageView = StarsView()
    
    var currentLevel: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // --- ИЗМЕНЕНИЯ СТИЛЯ ---
        
        // 1. Увеличенное скругление углов (современный стиль)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true // Очень важно, чтобы градиент обрезался
        
        // 2. Более мягкая и заметная тень (наносим на саму ячейку, а не на contentView)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 10
        
        // Убираем старый фон, так как его заменяет градиент
        contentView.backgroundColor = .clear // Было .white.withAlphaComponent(0.3)
        
        // --- ВАШ ОРИГИНАЛЬНЫЙ КОД СТРУКТУРЫ ---
        
        // Добавляем градиентный слой
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Добавляем лейбл и звезду
        contentView.addSubview(titleLabel)
        contentView.addSubview(starImageView)
        
        // Настройка констрейнтов для лейбла
        titleLabel.snp.makeConstraints { make in
            // Устанавливаем в левой части ячейки
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(starImageView.snp.leading).offset(-10) // Ограничиваем лейбл перед звездой
        }
        
        // Настройка констрейнтов для иконки звезды
        starImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            // Предполагая, что StarsView имеет фиксированный размер
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Градиентный слой должен соответствовать размеру contentView
        gradientLayer.frame = contentView.bounds
        // Для оптимизации тени
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    // --- ВАШ ОРИГИНАЛЬНЫЙ КОД ФУНКЦИОНАЛЬНОСТИ ---
    
    func configure(viewModel: BaseCellViewModel) {
        // Настройка ячейки с использованием viewModel
    }
    
    func setLabel(text: String, currentLevel: Int) {
        titleLabel.text = text
        self.currentLevel = currentLevel
        
        let currentLevelprogress = LevelProgreeHelper.shared.levelProgres[currentLevel - 1]
        var progressStarsCount = 0
        if currentLevelprogress.isFinished {
            progressStarsCount += 1
        }
        if currentLevelprogress.isTime {
            progressStarsCount += 1
        }
        if currentLevelprogress.isError {
            progressStarsCount += 1
        }
        
        starImageView.updateColor(progressStarsCount: progressStarsCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
