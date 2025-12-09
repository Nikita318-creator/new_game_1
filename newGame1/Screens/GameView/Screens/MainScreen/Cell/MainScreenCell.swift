//
//  MainScreenCell.swift
//  Baraban
//
//  Created by никита уваров on 24.08.24.
//

import UIKit
import SnapKit

class MainScreenCell: UICollectionViewCell, Cofigurable {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light) // Выберите стиль размытия, например .light, .dark, или .extraLight
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private let costBlurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark) // Выберите стиль размытия, например .light, .dark, или .extraLight
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isHidden = true
        return blurEffectView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 46, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    var isDisabled = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the imageView and bottomLabel to the cell's contentView
        contentView.addSubview(imageView)
        contentView.addSubview(bottomLabel)
        contentView.addSubview(blurEffectView)
        contentView.addSubview(costBlurEffectView)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 5
        blurEffectView.layer.cornerRadius = 30
        blurEffectView.clipsToBounds = true
        blurEffectView.alpha = 0.95
        costBlurEffectView.layer.cornerRadius = 30
        costBlurEffectView.clipsToBounds = true
        costBlurEffectView.alpha = 0.5
        
        // Setup constraints using SnapKit
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100) // Adjust this inset to fit the label
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(4) // Adjust this inset as needed
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
                
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
        costBlurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
    }
    
    func configure(viewModel: BaseCellViewModel) {
        // Configure the cell with the viewModel data
    }
    
    func setImage(image: UIImage, isChapterOpened: Bool, isCost: Bool) {
        imageView.image = image

        // Убедитесь, что blurEffectView накрывает imageView
        blurEffectView.layer.zPosition = 1
        blurEffectView.isHidden = isChapterOpened
        isDisabled = !isChapterOpened
        
        costBlurEffectView.isHidden = !isCost
    }
    
    func setLabelText(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        
        // Устанавливаем шрифт и цвет текста
        let font = UIFont.italicSystemFont(ofSize: 46) // Используем курсивный шрифт
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.count))
        
        // Устанавливаем черную обводку
        attributedString.addAttribute(.strokeColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.strokeWidth, value: -3.0, range: NSRange(location: 0, length: text.count)) // Отрицательное значение для обводки
        
        bottomLabel.attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
