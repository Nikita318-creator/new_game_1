//
//  CoinDayView.swift
//  Baraban
//
//  Created by никита уваров on 29.08.24.
//

import UIKit
import SnapKit

class CoinDayView: UIView {
    
    var coinCountLabel = UILabel()
    var dayCountLabel = UILabel()

    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor

        
        addSubview(coinCountLabel)
        addSubview(dayCountLabel)
        
        coinCountLabel.font = UIFont.FontsName.mainFont.value.withSize(20)
        dayCountLabel.font = UIFont.FontsName.mainFont.value.withSize(10)
        coinCountLabel.textAlignment = .center
        dayCountLabel.textAlignment = .center
        coinCountLabel.textColor = .systemGray
        dayCountLabel.textColor = .systemGray

        dayCountLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(22)
        }
        
        coinCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dayCountLabel.snp.top)
        }
    }
    
    func setDay(day: String, coins: String) {
        dayCountLabel.text = "Coins.Day".localized() + day
        coinCountLabel.text = "+\(coins)💲"
    }
}
