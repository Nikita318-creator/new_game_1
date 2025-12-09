//
//  AgreementScreenVC.swift
//  Baraban
//
//  Created by никита уваров on 25.08.24.
//

import UIKit
import SnapKit

class AgreementScreenVC: UIViewController {
    
    private enum Const {
        static let backgroundImageName = "mainBackGraund"
        static let agreementText = "AgreementText".localized()
        static let versionLabelText = "Version: 1.0.0 (Build 100)"
    }
    
    private let textView = UITextView()
    private let versionLabel = UILabel()
    
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

        // Настройка лейбла версии
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            versionLabel.text = "Version: \(version ?? "1.0") (Build \(buildNumber ?? "1"))"
        
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textColor = .white
        versionLabel.textAlignment = .center
        view.addSubview(versionLabel)
        
        // Констрейнты для textView
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(versionLabel.snp.top).offset(-10)
        }
        
        // Констрейнты для versionLabel
        versionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
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
        
        let font = UIFont.systemFont(ofSize: 16)
        
        // Основной текст
        let agreementText = Const.agreementText
        // Текст контактной информации
        let contactInfoText = "\n\nContact information: nikuvar77@gmail.com"
        
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
        let fullText = NSMutableAttributedString(string: agreementText, attributes: attributes)
        let contactText = NSAttributedString(string: contactInfoText, attributes: contactAttributes)
        fullText.append(contactText)
        
        textView.attributedText = fullText
        
        // Добавление текстового поля на экран
        view.addSubview(textView)
    }

}

// Расширение для удобства создания NSShadow
extension NSShadow {
    func apply(_ block: (NSShadow) -> Void) -> NSShadow {
        block(self)
        return self
    }
}
