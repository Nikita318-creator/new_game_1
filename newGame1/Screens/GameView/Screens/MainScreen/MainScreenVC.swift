

import UIKit
import SnapKit

class MainScreenVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum Const {
        static let bacgraundImagename = "mainBackGraund"
        static let screen = UIScreen.main.bounds
        static let cellWidthScale: CGFloat = 0.7 // Процент от ширины экрана для ячейки
    }

    private var collectionView: UICollectionView!
    private let viewModel = MainScreenCellViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupCollectionView()
        
        if GameLogicHelper.shared.getMainonbording() == false {
            GameLogicHelper.shared.saveMainonbording(true)
            let onboardingView = OnboardingView()
            onboardingView.setup(onboardingtype: .main)
            view.addSubview(onboardingView)
            onboardingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: (GameLogicHelper.shared.getFinishedChapters().max() ?? 1) - 1, section: 0)
        guard collectionView.numberOfItems(inSection: indexPath.section) > indexPath.item else { return }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Убедитесь, что коллекция полностью загружена
        let indexPath = IndexPath(item: (GameLogicHelper.shared.getFinishedChapters().max() ?? 1) - 1, section: 0)
        guard collectionView.numberOfItems(inSection: indexPath.section) > indexPath.item else { return }
        
        // Прокрутите к нужной ячейке, если она видима
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if !visibleIndexPaths.contains(indexPath) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func setupBackground() {
        // Создание UIImageView для фона
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: Const.bacgraundImagename)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40 // Расстояние между ячейками
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40) // Отступы для ячеек

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(MainScreenCell.self, forCellWithReuseIdentifier: "MainScreenCell")

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Const.screen.width)
            make.height.equalTo(2/3 * Const.screen.height)
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenCell", for: indexPath) as? MainScreenCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .clear
        let isChapterOpened = GameLogicHelper.shared.getFinishedChapters().contains(indexPath.item + 1)
        cell.setImage(
            image: viewModel.data[indexPath.item].image,
            isChapterOpened: isChapterOpened || indexPath.item == 5,
            isCost: indexPath.item == 5 && !LevelProgreeHelper.shared.getManyLevels()
        )

        cell.setLabelText(text: viewModel.data[indexPath.item].chapterName)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = Const.screen.width * Const.cellWidthScale
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  
            (collectionView.cellForItem(at: indexPath) as? MainScreenCell)?.isDisabled == false
        else {
            return
        }
        
        if indexPath.item + 1 == 6 { // дополнительные 50 ПЛАТНЫХ уровней после прохождения сюжета
            openManyLevels(indexPath: indexPath)
        } else if indexPath.item + 1 == 5 { // дополнительные 50 уровней после прохождения сюжета
            let extraChaptersScreen = ExtraChaptersScreenVC()
            extraChaptersScreen.gameMod = .freeFall
            extraChaptersScreen.currentChapter = indexPath.item
            GameLogicHelper.shared.currentChapter = indexPath.item + 1
            print("Current Chapter = \(indexPath.item + 1)")
            self.navigationController?.pushViewController(extraChaptersScreen, animated: true)
        } else {
            let chaptersScreenVC = ChaptersScreenVC()
            
            chaptersScreenVC.goToMainScreenAfterChapterFinished = { [weak self] in
                guard let self else { return }
                self.navigationController?.popToViewController(self, animated: false)
            }

            chaptersScreenVC.currentChapter = indexPath.item
            GameLogicHelper.shared.currentChapter = indexPath.item + 1
            print("Current Chapter = \(indexPath.item + 1)")
            self.navigationController?.pushViewController(chaptersScreenVC, animated: true)
        }
    }
    
    private func openManyLevels(indexPath: IndexPath) {
        if LevelProgreeHelper.shared.getManyLevels() {
            let extraChaptersScreen = ExtraChaptersScreenVC()
            extraChaptersScreen.currentChapter = indexPath.item
            extraChaptersScreen.gameMod = .manyLevels
            GameLogicHelper.shared.currentChapter = indexPath.item + 1
            print("Current Chapter = \(indexPath.item + 1)")
            
            self.navigationController?.pushViewController(extraChaptersScreen, animated: true)
        } else {
            LevelProgreeHelper.shared.saveManyLevels(true)
            collectionView.reloadData()
        }
    }
    
    private func showAlert(title: String, message: String, complition: @escaping (() -> Void)) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title: "OK".localized(),
            style: .destructive,
            handler: { _ in
                complition()
            }))
        
        present(alert, animated: true, completion: nil)
    }
}
