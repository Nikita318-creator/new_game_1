//
//  LastVisitDateView.swift
//  Baraban
//
//  Created by никита уваров on 29.08.24.
//

import UIKit
import SnapKit

class LastVisitDateView: UIView {

    private var dayViews: [CoinDayView] = []
    private let totalDays = 5
    private let coinValues = [1, 2, 3, 4, 5]

    private let okButton = UIButton(type: .system)
    let gradientLayer = CAGradientLayer()

    // Добавляем два лейбла для отображения награды
    private let rewardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.FontsName.simpleFont.value.withSize(26)
        label.textColor = .white
        return label
    }()

    private let rewardSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.FontsName.simpleFont.value
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var didTapOkHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setupGradient()
        setupRewardLabels() // Настраиваем лейблы награды
        setupOkButton()
        setupDayViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 0.0, green: 0.0, blue: 0.7, alpha: 1.0).cgColor,
            UIColor(red: 0.0, green: 0.0, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.3, 0.7, 1.0]
        gradientLayer.frame = bounds
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupRewardLabels() {
        addSubview(rewardTitleLabel)
        addSubview(rewardSubTitleLabel)

        // Настраиваем constraints для лейблов
        rewardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }

        rewardSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupDayViews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)

        for day in 1...totalDays {
            let dayView = CoinDayView()
            dayView.setup()
            dayView.setDay(day: "\(day)", coins: "\(coinValues[day - 1])")
            dayViews.append(dayView)
            stackView.addArrangedSubview(dayView)
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(okButton.snp.top).offset(-5)
            make.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(110)
        }
    }

    private func setupOkButton() {
        okButton.setTitle("OK", for: .normal)
        okButton.layer.cornerRadius = 35
        okButton.layer.borderWidth = 5
        okButton.layer.borderColor = UIColor.white.cgColor
        okButton.setTitleColor(.white, for: .normal)
        okButton.setTitleColor(.gray, for: .selected)
        okButton.titleLabel?.font = UIFont.FontsName.mainFont.value.withSize(30)
        okButton.addTarget(self, action: #selector(didTapOkButton), for: .touchUpInside)
        addSubview(okButton)

        okButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
    }

    @objc private func didTapOkButton() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        didTapOkHandler?()
        self.removeFromSuperview()
    }

    func updateView(forStreak streak: Int) {
        let currentStreak = min(streak, totalDays)

        for (index, dayView) in dayViews.enumerated() {
            let isActive = index == currentStreak - 1
            dayView.coinCountLabel.textColor = isActive ? .white : .gray
            dayView.dayCountLabel.textColor = isActive ? .white : .gray
            dayView.layer.borderColor = isActive ? UIColor.white.cgColor : UIColor.gray.cgColor
            dayView.layer.borderWidth = isActive ? 4 : 2
            
            if isActive {
                rewardTitleLabel.text = "Coins.RewardTitle".localized() + "+\(currentStreak)💲"
                rewardSubTitleLabel.text = "Coins.RewardSubTitle".localized()
            }
        }
    }
}
