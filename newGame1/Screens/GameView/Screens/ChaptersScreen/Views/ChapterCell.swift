//
//  ChapterCell.swift
//  Baraban
//
//  Created by никита уваров on 24.08.24.
//

import UIKit
import SnapKit

class ChapterCell: UICollectionViewCell, Cofigurable {
    
    // Лейбл для текста
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Bold", size: 74) // Используйте здесь название вашего кастомного шрифта
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
    
    private let starImageView = StarsView()
//    private let starImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "star.fill") // Заполненная звезда
//        imageView.tintColor = .red // Цвет иконки
//        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true // Сначала скрываем иконку
//        return imageView
//    }()
    
    var currentLevel: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            make.center.equalToSuperview()
        }
        
        // Настройка констрейнтов для иконки звезды
        starImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
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
