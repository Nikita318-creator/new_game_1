import UIKit
import SnapKit

class ScoreView: UIView {
    
    private let labels: [UILabel] = {
        let labels = (1...4).map { index -> UILabel in
            let label = UILabel()
            label.text = ""
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.font = UIFont.FontsName.simpleFont.value.withSize(22)
            return label
        }
        return labels
    }()
    
    private let starsView = StarsView()
    
    func setupLabels(time: TimeInterval, errors: Int) {
        // Добавление лейблов на представление
        labels.forEach { addSubview($0) }
        addSubview(starsView)
        let formattedTime = formatTimeInterval(time)

        labels[0].text = "ScoreView.errors".localized() + "\(errors)"
        labels[0].textColor = .black

        labels[1].text = errors < 2 ? "ScoreView.Great".localized() : "ScoreView.NotBad".localized()
        labels[1].textColor = errors < 2 ? UIColor(red: 0.98, green: 0.45, blue: 0.2, alpha: 1) : UIColor(red: 0.12, green: 0.73, blue: 0.39, alpha: 1)

        labels[2].text = "ScoreView.Time".localized() + "\(formattedTime)"
        labels[2].textColor = .black
        
        labels[3].text = time < 30 ? "ScoreView.Great".localized() : "ScoreView.NotBad".localized()
        labels[3].textColor = time < 30 ? UIColor(red: 0.98, green: 0.45, blue: 0.2, alpha: 1) : UIColor(red: 0.12, green: 0.73, blue: 0.39, alpha: 1)
        
        // Установка констрейнтов
        labels[0].snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        labels[1].snp.makeConstraints { make in
            make.top.equalTo(labels[0])
            make.trailing.equalToSuperview().inset(30)
        }
        labels[2].snp.makeConstraints { make in
            make.top.equalTo(labels[0].snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
        }
        labels[3].snp.makeConstraints { make in
            make.top.equalTo(labels[2])
            make.trailing.equalToSuperview().inset(30)
        }
        
        starsView.snp.makeConstraints { make in
            make.top.equalTo(labels[2].snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        let progressStarsCount = 1 + (errors < 2 ? 1 : 0) + (time < 30 ? 1 : 0)
        starsView.updateColor(progressStarsCount: progressStarsCount)
    }
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
