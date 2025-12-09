//
//  BlockAddsCell.swift
//  Baraban
//
//  Created by никита уваров on 6.09.24.
//

import UIKit
import SnapKit

class BlockAddsCell: UICollectionViewCell {
    let blockAdsButton = UIButton()
    var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Настройка кнопки
        blockAdsButton.setTitle("StoreScreen.BlockAddsCell.Buttontitle".localized(), for: .normal)
        blockAdsButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 22) // Пример с кастомным шрифтом
        blockAdsButton.setTitleColor(.white, for: .normal)
        blockAdsButton.layer.borderWidth = 6
        blockAdsButton.layer.borderColor = UIColor.white.cgColor
        blockAdsButton.backgroundColor = UIColor(red: 128/255, green: 0/255, blue: 32/255, alpha: 1.0)
        blockAdsButton.addTarget(self, action: #selector(blockAdsButtonTapped), for: .touchUpInside) // Добавляем таргет

        blockAdsButton.layer.cornerRadius = 20
        contentView.addSubview(blockAdsButton)
        
        blockAdsButton.snp.makeConstraints { make in
            make.center.equalToSuperview() // Центрируем кнопку
            make.height.equalTo(64) // Высота кнопки
            make.width.equalToSuperview().multipliedBy(0.8) // Ширина кнопки 80% от ширины ячейки
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func blockAdsButtonTapped() {
        // Создание и отображение алерта
        let alert = UIAlertController(
            title: "StoreScreen.BlockAddsCell.title".localized(),
            message: "StoreScreen.BlockAddsCell.message".localized() + " 10 000 " + "StoreScreen.Buy.Coins.Text".localized() + "?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title:  "StoreScreen.BlockAddsCell.confirm".localized(),
            style: .destructive,
            handler: { [weak self] _ in
                if CoinsHelper.shared.getSpecialCoins() >= PriceConst.blockAddsCost {
                    CoinsHelper.shared.saveSpecialCoins(CoinsHelper.shared.getSpecialCoins() - PriceConst.blockAddsCost)
                    PurchasedLogicHelper.shared.saveShowAdds(true)

                    // TODO: - логика отключения рекламы в приложении
                    
                } else {
                    self?.showAlertNotEnothMoney()
                }
            }))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertNotEnothMoney() {
        let alert = UIAlertController(
            title: "StoreScreen.Buy.Coins.NotEnath.Title".localized(),
            message: "StoreScreen.Buy.Coins.NotEnath.Message".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title: "OK".localized(),
            style: .destructive,
            handler: { [weak self] _ in

            }))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
