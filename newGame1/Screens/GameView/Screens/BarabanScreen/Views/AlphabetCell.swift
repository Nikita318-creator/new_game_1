import UIKit
import SnapKit

class AlphabetCell: UICollectionViewCell {
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.FontsName.mainFont.value
        
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(letterLabel)
        // Удаляем границу и округление углов
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 0

        letterLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with letter: String) {
        letterLabel.text = letter
    }
    
    func setRedColor() {
        letterLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.letterLabel.textColor = .black
        }
    }
}
