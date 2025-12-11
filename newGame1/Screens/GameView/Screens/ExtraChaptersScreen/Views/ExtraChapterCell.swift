

import UIKit
import SnapKit

class ExtraChapterCell: UICollectionViewCell, Cofigurable {
    
    // Лейбл для текста
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Bold", size: 28) // Используйте здесь название вашего кастомного шрифта
        label.textAlignment = .center
        label.numberOfLines = 0 // Это позволит лейблу занимать несколько строк, если текст слишком длинный
        return label
    }()
    
    // Градиентный слой
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.darkGray.withAlphaComponent(0.8).cgColor, UIColor.lightGray.withAlphaComponent(0.8).cgColor] // Более серый градиент
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        return gradient
    }()
    
    private let starImageView = ExtraStarsView()
    
    var currentLevel: Int = 0
    var isOpened: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        layer.borderWidth = 5
        layer.borderColor = UIColor(red: 0/255, green: 51/255, blue: 255/255, alpha: 1.0).withAlphaComponent(0.5).cgColor
        clipsToBounds = true
        
        // Настройка тени
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        // Добавляем градиентный слой
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Добавляем лейбл на ячейку
        contentView.addSubview(titleLabel)
        
        // Добавляем иконку звезды на ячейку
        contentView.addSubview(starImageView)
        
        // Настройка констрейнтов для лейбла
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        // Настройка констрейнтов для иконки звезды
        starImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(5)
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        // Настройка прозрачности ячейки
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    func configure(viewModel: BaseCellViewModel) {
        // Настройка ячейки с использованием viewModel
    }
    
    func setLabel(text: String, currentLevel: Int, gameMod: GameMod) {
        titleLabel.text = text
        self.currentLevel = currentLevel
        
        let currentLevelprogress: LevelProgres = gameMod == .freeFall
            ? LevelProgreeHelper.shared.extraLevelProgres[currentLevel - 1]
            : LevelProgreeHelper.shared.manyLevelProgres[currentLevel - 1]
        
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
        
        let finishedLevelsCount = gameMod == .freeFall
            ? GameLogicHelper.shared.getFinishedExtraLevel().count + 1
            : GameLogicHelper.shared.getFinishedManyLevel().count + 1
        
        if currentLevel <= finishedLevelsCount {
            isOpened = true
            layer.borderColor = UIColor(red: 0/255, green: 51/255, blue: 255/255, alpha: 1.0).withAlphaComponent(0.5).cgColor
        } else {
            isOpened = false
            layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
