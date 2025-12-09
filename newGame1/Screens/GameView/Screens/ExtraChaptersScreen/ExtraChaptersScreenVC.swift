//
//  ExtraChaptersScreenVC.swift
//  Baraban
//
//  Created by никита уваров on 1.09.24.
//

import UIKit
import SnapKit

class ExtraChaptersScreenVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private enum Const {
        static let backgroundImageName = "mainBackGraund"
        static let screen = UIScreen.main.bounds
        static let cellHeight: CGFloat = 100 // Высота ячейки
        static let cellSpacing: CGFloat = 10 // Расстояние между ячейками
        static let sectionInset: CGFloat = 10 // Отступы с каждой стороны
        static let numberOfCellsInRow: CGFloat = 6 // Количество ячеек в ряду
    }
    
    private var collectionView: UICollectionView!
    var currentChapter: Int = 0
    
    var gameMod: GameMod = .freeFall
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        collectionView.setContentOffset(CGPoint(x: 0, y: -200), animated: true)
//    }
    
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
        layout.minimumInteritemSpacing = Const.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: Const.sectionInset, left: Const.sectionInset, bottom: Const.sectionInset, right: Const.sectionInset)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ExtraChapterCell.self, forCellWithReuseIdentifier: "ExtraChapterCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraChapterCell", for: indexPath) as? ExtraChapterCell else {
            return UICollectionViewCell()
        }
        
        let currentLevel = indexPath.item + 1
        cell.backgroundColor = .clear
        cell.setLabel(text: "\(indexPath.item + 1)", currentLevel: currentLevel, gameMod: gameMod)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (Const.numberOfCellsInRow - 1) * Const.cellSpacing + 2 * Const.sectionInset
        let width = (Const.screen.width - totalSpacing) / Const.numberOfCellsInRow
        let height = width + 26 // Const.cellHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Const.sectionInset, left: Const.sectionInset, bottom: Const.sectionInset, right: Const.sectionInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (collectionView.cellForItem(at: indexPath) as? ExtraChapterCell)?.isOpened == true else { return }
        
        let barabanScreenVC = BarabanScreenVC()
        barabanScreenVC.viewModel.gameMod = gameMod
        barabanScreenVC.currentLevel = indexPath.item
        print("Current level = \(barabanScreenVC.currentLevel + 1)")
        if gameMod == .freeFall {
            GameLogicHelper.shared.currentExtraLevel = barabanScreenVC.currentLevel + 1
        } else {
            GameLogicHelper.shared.currentManyLevel = barabanScreenVC.currentLevel + 1
        }
        self.navigationController?.pushViewController(barabanScreenVC, animated: true)
    }
}
