//
//  PopUpView.swift
//  Baraban
//
//  Created by никита уваров on 1.09.24.
//

import UIKit
import SnapKit

class PopUpView: UIView {
    
    private let messageLabel = UILabel() // Создаем UILabel для отображения текста
    
    var isBarabanTapped = false
    var isKeyboardTapped = false
    var isTrueTapped = false
    var isFalseTapped = false
    var isHelpTapped = false

    func setup(text: String) {
        // Устанавливаем размер и положение попапа
        self.frame = CGRect(x: 0, y: -150, width: UIScreen.main.bounds.width, height: 150) // Начальная позиция за пределами экрана сверху
        self.backgroundColor = .systemBlue // Пример цвета фона
        
        // Добавляем тень и радиус скругления
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        // Настройка лейбла
        messageLabel.text = text // Устанавливаем текст для лейбла
        messageLabel.textColor = .white
        messageLabel.font = UIFont.FontsName.simpleFont.value.withSize(18)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        self.addSubview(messageLabel) // Добавляем лейбл в PopUpView
        
        // Устанавливаем ограничения для лейбла с помощью SnapKit
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10) // Лейбл будет занимать всю область внутри PopUpView с отступом 10 пунктов
        }
    }
    
    func show(isNeedHide: Bool = true) {
        // Check if a PopUpView is already being shown
        guard
            let window = UIApplication.shared.windows.first,
            !window.subviews.contains(where: { $0 is PopUpView })
        else {
            return
        }

        window.addSubview(self)
        
        // Анимация появления попапа сверху экрана
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame.origin.y = 0 // Попап переместится в верхнюю часть экрана
        }, completion: { _ in
            // Автоматически скрываем попап через 2 секунды
            guard isNeedHide else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.hide()
            }
        })
    }
    
    func hide() {
        // Анимация скрытия попапа обратно вверх
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.frame.origin.y = -150 // Возвращаем попап за пределы экрана сверху
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
