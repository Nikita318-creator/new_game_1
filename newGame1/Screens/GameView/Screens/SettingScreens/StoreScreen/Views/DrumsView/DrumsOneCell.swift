
import UIKit
import SnapKit

class DrumsOneCell: UICollectionViewCell {

   // Создаем элементы интерфейса
   private let imageView: UIImageView = {
       let imageView = UIImageView()
//       imageView.backgroundColor = .black.withAlphaComponent(0.5)
       imageView.contentMode = .scaleAspectFit
       return imageView
   }()
   
   private let titleLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.FontsName.mainFont.value.withSize(26)
       label.textColor = UIColor(red: 0.72, green: 0.53, blue: 0.04, alpha: 1.0)
//       label.backgroundColor = .black.withAlphaComponent(0.5)
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
       
       // Настраиваем констрейнты с использованием SnapKit
       imageView.snp.makeConstraints { make in
           make.top.equalToSuperview()
           make.leading.trailing.equalToSuperview()
       }

       titleLabel.snp.makeConstraints { make in
           make.top.equalTo(imageView.snp.bottom)
           make.leading.trailing.equalToSuperview()
           make.height.equalTo(46)
           make.bottom.equalToSuperview().offset(0) // Отступ от нижней границы ячейки
       }
   }
   
   // Метод для обновления содержимого ячейки
   func configure(image: UIImage?, title: String) {
       imageView.image = image
       titleLabel.text = title
   }
    
    func updateDidSelect(isSelect: Bool) {
        if isSelect {
            imageView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            titleLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        } else {
            imageView.backgroundColor = .black.withAlphaComponent(0.5)
            titleLabel.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
}
