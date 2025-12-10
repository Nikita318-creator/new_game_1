//
//  PopUpView.swift
//  Baraban
//
//  Created by никита уваров on 1.09.24.
//

import UIKit
import SnapKit

class PopUpView: UIView {
    
    private let messageLabel = UILabel()
    
    var isBarabanTapped = false
    var isKeyboardTapped = false
    var isTrueTapped = false
    var isFalseTapped = false
    var isHelpTapped = false

    func setup(text: String) {
        self.frame = CGRect(x: 0, y: -150, width: UIScreen.main.bounds.width, height: 150)
        self.backgroundColor = .systemBlue
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        messageLabel.text = text
        messageLabel.textColor = .white
        messageLabel.font = UIFont.FontsName.simpleFont.value.withSize(18)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        self.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func show(isNeedHide: Bool = true) {
        guard
            let window = UIApplication.shared.windows.first,
            !window.subviews.contains(where: { $0 is PopUpView })
        else {
            return
        }

        window.addSubview(self)
        
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
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.frame.origin.y = -150 // Возвращаем попап за пределы экрана сверху
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
