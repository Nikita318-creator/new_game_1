

import UIKit
import SnapKit

class OnboardingCell: UICollectionViewCell {

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OnboardingCell.skip".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true // Позволяет уменьшать размер шрифта
        label.minimumScaleFactor = 0.5 // Минимальный масштаб, до которого уменьшится шрифт (50% от начального размера)
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OnboardingCell.next".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    var skipHandler: (() -> Void)?
    var nextHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(skipButton)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(nextButton)
    }

    private func setupConstraints() {
        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(skipButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.height).multipliedBy(0.4)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(150)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
    }
    
    func setup(image: UIImage?, text: String) {
        imageView.image = image
        label.text = text
    }
    
    @objc private func skipButtonTapped() {
        skipHandler?()
    }

    @objc private func nextButtonTapped() {
        nextHandler?()
    }
}


