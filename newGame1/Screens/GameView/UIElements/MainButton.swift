//
//  MainButton.swift
//  Baraban
//
//  Created by никита уваров on 23.08.24.
//


import UIKit

class MainButton: UIButton {
    
    convenience init(
        color: UIColor? = nil,
        title: String? = nil,
        font: UIFont? = nil,
        isActive: Bool? = nil
    ) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.FontsName.mainFont.value.withSize(30)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
        clipsToBounds = true
        layer.cornerRadius = 4
        
        setup()
    }
    
    private func setup() {
        
        // Настройка градиентного слоя
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.4, blue: 1.0, alpha: 1.0).cgColor, // Ярко-синий
            UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0).cgColor  // Глубокий синий
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Настройка сильной тени
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.masksToBounds = false
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Обновляем рамку градиентного слоя при изменении размеров кнопки
        layer.sublayers?.first?.frame = bounds
    }
}
