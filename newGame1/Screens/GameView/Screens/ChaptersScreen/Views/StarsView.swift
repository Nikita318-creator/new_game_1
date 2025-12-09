//
//  StarsView.swift
//  Baraban
//
//  Created by никита уваров on 30.08.24.
//

import UIKit
import SnapKit

class StarsView: UIView {
    
    let star1 = StarView()
    let star2 = StarView()
    let star3 = StarView()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Настройка стека
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8 // Отступы между звездами
        
        // Добавление звезд в стек
        stackView.addArrangedSubview(star1)
        stackView.addArrangedSubview(star2)
        stackView.addArrangedSubview(star3)
        
        // Добавление стека на экран
        addSubview(stackView)
        
        // Настройка ограничений для стека
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Стек займет все пространство доступное вью
        }
        
        // Настройка звезды
        [star1, star2, star3].forEach {
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(34) // Устанавливаем размеры для звезд
            }
        }
    }
    
    func updateColor(progressStarsCount: Int) {
        switch progressStarsCount {
        case 1:
            star1.updateColor()
            star2.setDefault()
            star3.setDefault()
        case 2:
            star1.updateColor()
            star2.updateColor()
            star3.setDefault()
        case 3:
            star1.updateColor()
            star2.updateColor()
            star3.updateColor()
        default:
            star1.setDefault()
            star2.setDefault()
            star3.setDefault()
        }
    }
}
