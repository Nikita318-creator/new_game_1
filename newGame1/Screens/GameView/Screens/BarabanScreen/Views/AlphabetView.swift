import UIKit
import SnapKit
import AudioToolbox

class AlphabetView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var data = Array("AlphabetView".localized())

    private var collectionView: UICollectionView!

    var cellTapedHandler: ((String) -> Bool)?
    var showPopUpHandler: (() -> Void)?

    private var tapCount = 0
    private var isBlocked = false
    private var tapTimer: Timer?
    private var lastTapDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        shuffledData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shuffledData() {
        let oldData = data
        data = data.shuffled()
        let indexPaths = oldData.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: indexPaths)
        }, completion: { _ in
            // После завершения анимации обновления данных можно запустить плавную анимацию перемешивания
            self.animateShuffling()
        })
    }

    private func animateShuffling() {
        collectionView.visibleCells.forEach { cell in
            let originalFrame = cell.frame
            let randomX = CGFloat.random(in: 0...collectionView.bounds.width)
            let randomY = CGFloat.random(in: 0...collectionView.bounds.height)
            let randomOffset = CGPoint(x: randomX, y: randomY)
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.transform = CGAffineTransform(translationX: randomOffset.x - originalFrame.origin.x, y: randomOffset.y - originalFrame.origin.y)
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    cell.transform = .identity
                })
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlphabetCell.self, forCellWithReuseIdentifier: "AlphabetCell")

        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlphabetCell", for: indexPath) as? AlphabetCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: String(data[indexPath.item]))
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Уменьшаем размер ячеек, увеличив количество ячеек в строке
        let numberOfCellsPerRow: CGFloat = 8 // Увеличиваем количество ячеек в строке
        let padding: CGFloat = 5 * (numberOfCellsPerRow - 1) // Зазоры между ячейками
        let totalAvailableWidth = collectionView.bounds.width - padding
        let cellWidth = totalAvailableWidth / numberOfCellsPerRow
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Получаем ячейку по индексу
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlphabetCell else { return }
            
        // Если кнопки заблокированы, ничего не делаем
           if isBlocked {
               showPopUpHandler?()
               return
           }

           // Устанавливаем текущее время
           let currentDate = Date()

           // Проверяем, если прошло больше 3 секунд с последнего нажатия
           if let lastTapDate = lastTapDate, currentDate.timeIntervalSince(lastTapDate) > 3.0 {
               // Если прошло больше 3 секунд, сбрасываем счетчик нажатий
               tapCount = 0
           }

           // Обновляем время последнего нажатия
           lastTapDate = currentDate

           // Увеличиваем счетчик нажатий
           tapCount += 1

           // Если количество нажатий больше или равно 3
           if tapCount >= 3 {
               // Блокируем дальнейшие нажатия
               isBlocked = true

               // Очищаем счетчик нажатий
               tapCount = 0

               // Настраиваем таймер для разблокировки через 2 секунды
               tapTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
                   self?.isBlocked = false
               }
           }
        
        if cellTapedHandler?(String(data[indexPath.item])) == false {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            cell.setRedColor()
        } else {
            
        }
    }
}
