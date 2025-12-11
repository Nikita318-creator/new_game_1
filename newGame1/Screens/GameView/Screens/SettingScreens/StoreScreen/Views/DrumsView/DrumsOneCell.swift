
import UIKit
import SnapKit

class DrumsOneCell: UICollectionViewCell {

   private let containerView: UIView = {
       let view = UIView()
       view.layer.borderWidth = 3
       view.layer.borderColor = UIColor(red: 128/255, green: 0/255, blue: 32/255, alpha: 1.0).cgColor
       view.layer.cornerRadius = 8
       view.clipsToBounds = true
       return view
   }()
    
   private let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.layer.cornerRadius = 8
       imageView.clipsToBounds = true
       return imageView
   }()
   
   private let titleLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.FontsName.mainFont.value.withSize(22)
       label.textColor = UIColor(red: 0.72, green: 0.53, blue: 0.04, alpha: 1.0)
       label.textAlignment = .center
       label.numberOfLines = 1
       label.adjustsFontSizeToFitWidth = true
       label.minimumScaleFactor = 0.7
       return label
   }()
    
   private let selectionIndicator: UIView = {
       let view = UIView()
       view.backgroundColor = .systemGreen
       view.layer.cornerRadius = 4
       view.alpha = 0
       return view
   }()

   override init(frame: CGRect) {
       super.init(frame: frame)
       setupUI()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   private func setupUI() {
       backgroundColor = .clear
       
       contentView.addSubview(containerView)
       containerView.addSubview(imageView)
       containerView.addSubview(titleLabel)
       containerView.addSubview(selectionIndicator)
       
       containerView.snp.makeConstraints { make in
           make.edges.equalToSuperview().inset(4)
       }
       
       imageView.snp.makeConstraints { make in
           make.top.leading.trailing.equalToSuperview()
           make.bottom.equalTo(titleLabel.snp.top)
       }
       
       titleLabel.snp.makeConstraints { make in
           make.leading.trailing.equalToSuperview().inset(6)
           make.bottom.equalToSuperview()
           make.height.equalTo(40)
       }
       
       selectionIndicator.snp.makeConstraints { make in
           make.top.leading.equalToSuperview().inset(8)
           make.width.height.equalTo(8)
       }
   }
   
   func configure(image: UIImage?, title: String) {
       imageView.image = image
       titleLabel.text = title
   }
    
    func updateDidSelect(isSelect: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            if isSelect {
                self.imageView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
                self.titleLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
                self.selectionIndicator.alpha = 1
                self.containerView.layer.borderWidth = 4
            } else {
                self.imageView.backgroundColor = .black.withAlphaComponent(0.5)
                self.titleLabel.backgroundColor = .black.withAlphaComponent(0.5)
                self.selectionIndicator.alpha = 0
                self.containerView.layer.borderWidth = 3
            }
        }
    }
}
