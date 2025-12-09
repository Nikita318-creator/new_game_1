//
//  FontsOneCell.swift
//  Baraban
//
//  Created by никита уваров on 7.09.24.
//

import UIKit
import SnapKit

class FontsOneCell: UICollectionViewCell {
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 204/255, green: 168/255, blue: 61/255, alpha: 1.0)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.font = UIFont.FontsName.mainFont.value.withSize(26)
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
        titleView.addSubview(titleLabel)
        contentView.addSubview(titleView)
        contentView.addSubview(subtitleLabel)
        
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(-4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(0) // Отступ от нижней границы ячейки
        }
    }
    
    // Метод для обновления содержимого ячейки
    func configure(cost: String, font: UIFont) {
        titleLabel.text = "AlphabetView".localized().replacingOccurrences(of: " ", with: "")
        titleLabel.font = font
        subtitleLabel.text = cost
    }
    
    func updateDidSelect(isSelect: Bool) {
        if isSelect {
            subtitleLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            titleView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        } else {
            subtitleLabel.backgroundColor = .black.withAlphaComponent(0.5)
            titleView.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
}
