//
//  SectionHeaderView.swift
//  Baraban
//
//  Created by никита уваров on 6.09.24.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.FontsName.mainFont.value.withSize(26)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        backgroundColor = UIColor(red: 15/255, green: 32/255, blue: 60/255, alpha: 1.0)
//        clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
