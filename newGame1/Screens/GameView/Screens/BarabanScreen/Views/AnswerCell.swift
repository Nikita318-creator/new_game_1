import UIKit
import SnapKit

// Класс для ячейки
class AnswerCell: UICollectionViewCell {
    
    var fontSize: CGFloat {
        if UIFont.FontsName.mainFont.value == UIFont.CostFont5 {
            return 14
        } else {
            return 26
        }
    }
    
    private lazy var letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.FontsName.mainFont.value.withSize(fontSize)
        label.textAlignment = .center
        return label
    }()

    var answerLetter = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(letterLabel)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 5

        letterLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, isCellMiniSize: Bool) {
        letterLabel.text = text
        letterLabel.font = isCellMiniSize
            ? UIFont.FontsName.mainFont.value.withSize(fontSize - 5)
            : UIFont.FontsName.mainFont.value.withSize(fontSize)
    }
}

