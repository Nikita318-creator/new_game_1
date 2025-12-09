//
//  OneCoinCell.swift
//  Baraban
//
//  Created by никита уваров on 6.09.24.
//
 
import UIKit
import SnapKit

class OneCoinCell: UICollectionViewCell {

    // Создаем элементы интерфейса
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.FontsName.mainFont.value.withSize(26)
        label.textColor = UIColor(red: 0.72, green: 0.53, blue: 0.04, alpha: 1.0)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.layer.borderWidth = 4
        label.layer.borderColor = UIColor(red: 128/255, green: 0/255, blue: 32/255, alpha: 1.0).cgColor
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.FontsName.mainFont.value.withSize(26)
        label.textColor = UIColor(red: 204/255, green: 168/255, blue: 61/255, alpha: 1.0)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.layer.borderWidth = 4
        label.layer.borderColor = UIColor(red: 128/255, green: 0/255, blue: 32/255, alpha: 1.0).cgColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.borderWidth = 4
        layer.borderColor = UIColor(red: 128/255, green: 0/255, blue: 32/255, alpha: 1.0).cgColor
        
        // Добавляем элементы на ячейку
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        // Настраиваем констрейнты с использованием SnapKit
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(-4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(0) // Отступ от нижней границы ячейки
        }
    }
    
    // Метод для обновления содержимого ячейки
    func configure(image: UIImage?, title: String, subtitle: String) {
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
