

import UIKit
import SnapKit

class ChaptersScreenVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private enum Const {
        static let backgroundImageName = "mainBackGraund"
        static let screen = UIScreen.main.bounds
        static let cellHeight: CGFloat = 100 // Высота ячейки
        static let cellSpacing: CGFloat = 20 // Расстояние между ячейками
        static let sectionInset: CGFloat = 20 // Отступы с каждой стороны
    }
    
    private var collectionView: UICollectionView!
    var currentChapter: Int = 0
    var goToMainScreenAfterChapterFinished: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupCollectionView()
        
        showOnboardingIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        if GameLogicHelper.shared.getFinishedLevel().count % 5 == 0 && GameLogicHelper.shared.getFinishedLevel().count != 0 {
            showFinishedOnboardingIfNeeded()
        }
    }
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: Const.backgroundImageName)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Const.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Const.sectionInset, bottom: 0, right: Const.sectionInset)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChapterCell.self, forCellWithReuseIdentifier: "ChapterCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterCell", for: indexPath) as? ChapterCell else {
            return UICollectionViewCell()
        }
        
        let currentLevel = (indexPath.item + 1) + (currentChapter * 5)
        cell.backgroundColor = .clear
        cell.setLabel(text: "\(indexPath.item + 1)", currentLevel: currentLevel)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Const.screen.width - 2 * Const.sectionInset // Ширина ячейки с учетом отступов
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let barabanScreenVC = BarabanScreenVC()
        barabanScreenVC.currentLevel = (indexPath.item + 1) + (currentChapter * 5) - 1
        print("Current level = \(barabanScreenVC.currentLevel + 1)")
        GameLogicHelper.shared.currentLevel = barabanScreenVC.currentLevel + 1
        self.navigationController?.pushViewController(barabanScreenVC, animated: true)
    }
}

// MARK: - Show Onboarding If Needed

extension ChaptersScreenVC {
    private func showOnboardingIfNeeded() {
        switch currentChapter {
        case 0:
            if GameLogicHelper.shared.getChapter1onbording() == false {
                GameLogicHelper.shared.saveChapter1onbording(true)
                let onboardingView = OnboardingView()
                onboardingView.setup(onboardingtype: .chapter1)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        case 1:
            if GameLogicHelper.shared.getChapter2onbording() == false {
                GameLogicHelper.shared.saveChapter2onbording(true)
                let onboardingView = OnboardingView()
                onboardingView.setup(onboardingtype: .chapter2)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        case 2:
            if GameLogicHelper.shared.getChapter3onbording() == false {
                GameLogicHelper.shared.saveChapter3onbording(true)
                let onboardingView = OnboardingView()
                onboardingView.setup(onboardingtype: .chapter3)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        case 3:
            if GameLogicHelper.shared.getChapter4onbording() == false {
                GameLogicHelper.shared.saveChapter4onbording(true)
                let onboardingView = OnboardingView()
                onboardingView.setup(onboardingtype: .chapter4)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        default: break
        }
    }
    
    private func showFinishedOnboardingIfNeeded() {
        switch currentChapter {
        case 0:
            if GameLogicHelper.shared.getChapter1Fonbording() == false && GameLogicHelper.shared.getFinishedLevel().count % 5 == 0 {
                GameLogicHelper.shared.saveChapter1Fonbording(true)
                let onboardingView = OnboardingView()
                onboardingView.goToMainScreenAfterChapterFinished = { [weak self] in
                    self?.goToMainScreenAfterChapterFinished?()
                }
                onboardingView.setup(onboardingtype: .chapterFinished1)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        case 1:
            if GameLogicHelper.shared.getChapter2Fonbording() == false && GameLogicHelper.shared.getFinishedLevel().count % 10 == 0 {
                GameLogicHelper.shared.saveChapter2Fonbording(true)
                let onboardingView = OnboardingView()
                onboardingView.goToMainScreenAfterChapterFinished = { [weak self] in
                    self?.goToMainScreenAfterChapterFinished?()
                }
                onboardingView.setup(onboardingtype: .chapterFinished2)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        case 2:
            if GameLogicHelper.shared.getChapter3Fonbording() == false && GameLogicHelper.shared.getFinishedLevel().count % 15 == 0 {
                GameLogicHelper.shared.saveChapter3Fonbording(true)
                let onboardingView = OnboardingView()
                onboardingView.goToMainScreenAfterChapterFinished = { [weak self] in
                    self?.goToMainScreenAfterChapterFinished?()
                }
                onboardingView.setup(onboardingtype: .chapterFinished3)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        case 3:
            if GameLogicHelper.shared.getChapter4Fonbording() == false && GameLogicHelper.shared.getFinishedLevel().count % 20 == 0 {
                GameLogicHelper.shared.saveChapter4Fonbording(true)
                let onboardingView = OnboardingView()
                onboardingView.goToMainScreenAfterChapterFinished = { [weak self] in
                    self?.goToMainScreenAfterChapterFinished?()
                }
                onboardingView.setup(onboardingtype: .chapterFinished4)
                view.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        default: break
        }
    }
}
