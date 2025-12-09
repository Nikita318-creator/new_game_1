//
//  MainCoinView.swift
//  Baraban
//
//  Created by никита уваров on 29.08.24.
//

import UIKit
import SnapKit

class MainCoinView: UIView {
    
    private let regularCoinsView = UIView() // минуты
    private let specialCoinsView = UIView() // монеты
    private let spacer = UIView()

    private let regularLabel = UILabel()
    private let specialLabel = UILabel()
    
    private let dollarsignImageView = UIImageView()
    private let clockImageView = UIImageView()
    
    private let plusButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func updateCoinsCount() {
        regularLabel.text = "\(formatNumber(CoinsHelper.shared.getRegularCoins()))"
        specialLabel.text = "\(formatNumber(CoinsHelper.shared.getSpecialCoins()))"
    }
    
    func setupView() {
        backgroundColor = .clear
        
        // Set up the oval shape
        layer.cornerRadius = 25
        layer.masksToBounds = true
        layer.borderColor = UIColor.darkBlue.cgColor // Темно-синий цвет
        layer.borderWidth = 4.0 // Увеличьте ширину обводки, если нужно
        
        // Set up regular coins view
        regularCoinsView.backgroundColor = UIColor.lightBlue // Светло-голубой цвет
        addSubview(regularCoinsView)
        
        // Set up special coins view
        specialCoinsView.backgroundColor = UIColor.lightBlue1 // Светло-голубой цвет
        addSubview(specialCoinsView)
        
        spacer.backgroundColor = UIColor.darkBlue
        addSubview(spacer)

        // Set up "+" button
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        plusButton.setTitleColor(UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0), for: .normal)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        specialCoinsView.addSubview(plusButton)
        
        specialCoinsView.addSubview(dollarsignImageView)
        dollarsignImageView.image = UIImage(systemName: "dollarsign.circle")
        dollarsignImageView.tintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        
        regularCoinsView.addSubview(clockImageView)
        clockImageView.image = UIImage(systemName: "clock.fill")
        clockImageView.tintColor = UIColor(red: 0.6, green: 0.0, blue: 0.1, alpha: 1.0)
        
        // Set up labels
        regularLabel.text = ""
        regularLabel.textColor = .black
        regularLabel.textAlignment = .center
        regularCoinsView.addSubview(regularLabel)
        
        specialLabel.text = ""
        specialLabel.textColor = .black
        specialLabel.textAlignment = .center
        specialCoinsView.addSubview(specialLabel)
        
        // Layout using SnapKit
        layoutViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRegularCoins))
        regularCoinsView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSpecialCoins), name: Notification.Name("saveSpecialCoins"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSpecialCoins), name: Notification.Name("saveRegularCoins"), object: nil)
    }
    
    private func layoutViews() {
        regularCoinsView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.41)
        }
        
        specialCoinsView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.56)
        }
        
        spacer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(regularCoinsView.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.03)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(30)
        }
        
        dollarsignImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(plusButton.snp.leading).inset(4)
            make.width.height.equalTo(30)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(30)
        }
        
        regularLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(clockImageView.snp.trailing).inset(-4)
        }
        
        specialLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(dollarsignImageView.snp.leading).inset(-4)
        }
    }
    
    @objc private func didTapPlusButton() {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            let storeScreenVC = StoreScreenVC()
//            rootViewController.navigationController?.pushViewController(storeScreenVC, animated: true)
            rootViewController.present(storeScreenVC, animated: true, completion: nil)
        }
    }
    
    @objc private func didTapRegularCoins() {
        guard GameLogicHelper.shared.getFinishedChapters().count < 5 else {
            let message = "\(CoinsHelper.shared.getRegularCoins())" + "Coins.RegularCoins.FinishedInfoMessage".localized()
            let alert = UIAlertController(title: "Coins.RegularCoins.Info".localized(), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            
            // Найдите текущий видимый ViewController, чтобы показать alert
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        let alert = UIAlertController(title: "Coins.RegularCoins.Info".localized(), message: "Coins.RegularCoins.InfoMessage".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        
        // Найдите текущий видимый ViewController, чтобы показать alert
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateSpecialCoins() {
        // Получаем текущие значения монет
        let regularCoins = CoinsHelper.shared.getRegularCoins()
        let specialCoins = CoinsHelper.shared.getSpecialCoins()
        
        // Обновляем текст лейблов
        if regularLabel.text != "\(formatNumber(regularCoins))" {
            regularLabel.text = "\(formatNumber(regularCoins))"
            // Анимация для regularLabel
            animateCoinLabel(label: regularLabel)
        }
        if specialLabel.text != "\(formatNumber(specialCoins))" {
            specialLabel.text = "\(formatNumber(specialCoins))"
            // Анимация для specialLabel
            animateCoinLabel(label: specialLabel)
        }
    }
    
    private func animateCoinLabel(label: UILabel) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            // Увеличиваем масштаб
            label.transform = CGAffineTransform(scaleX: 3, y: 3)
            label.alpha = 0.3 // Полупрозрачный
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                // Возвращаем к исходному масштабу и прозрачности
                label.transform = .identity
                label.alpha = 1.0
            })
        })
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let thousands = number / 1000
            return "\(thousands)k"
        } else {
            return "\(number)"
        }
    }
}

extension UIColor {
    static let darkBlue = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
    static let lightBlue = UIColor(red: 0.678, green: 0.847, blue: 0.902, alpha: 0.5) // light sky blue
    static let lightBlue1 = UIColor(red: 0.529, green: 0.808, blue: 0.922, alpha: 0.5) // light blue
}
