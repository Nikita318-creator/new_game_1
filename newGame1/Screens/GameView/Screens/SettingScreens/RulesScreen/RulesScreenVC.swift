//
//  RulesScreenVC.swift
//  Baraban
//
//  Created by никита уваров on 25.08.24.
//

import UIKit
import SnapKit

class RulesScreenVC: UIViewController {
    
    private enum Const {
        static let backgroundImageName = "mainBackGraund"
        static let rulesText = "RulesText".localized()
    }
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        // Создание UIImageView для фона
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: Const.backgroundImageName)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        // Настройка текстового поля
        setupTextView()

        // Констрейнты для textView
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupTextView() {
        // Настройка текстового поля
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = [.link] // Автоматическое распознавание ссылок
        textView.backgroundColor = .black.withAlphaComponent(0.5)
        
        let textColor = UIColor.white
        let shadowColor = UIColor.systemBlue
        let shadowOffset = CGSize(width: 1, height: 1)
        
        let font = UIFont.FontsName.simpleFont.value.withSize(18)
        
        let rulesText = Const.rulesText
        // Текст контактной информации
        let contactInfoText = " nikuvar77@gmail.com"
        
        // Создание атрибутов для основного текста
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: font,
            .shadow: NSShadow().apply {
                $0.shadowColor = shadowColor
                $0.shadowOffset = shadowOffset
            }
        ]
        
        // Создание атрибутов для контактной информации (подчеркнутый текст)
        let contactAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: font,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: URL(string: "mailto:nikuvar77@gmail.com")!
        ]
        
        // Создание комбинации текста
        let fullText = NSMutableAttributedString(string: rulesText, attributes: attributes)
        let contactText = NSAttributedString(string: contactInfoText, attributes: contactAttributes)
        fullText.append(contactText)
        
        textView.attributedText = fullText
        
        // Добавление текстового поля на экран
        view.addSubview(textView)
    }

}
