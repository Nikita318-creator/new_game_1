//
//  StoreScreenVC.swift
//  Baraban
//
//  Created by никита уваров on 25.08.24.
//

import UIKit
import SnapKit

enum PriceConst {
    static let blockAddsCost = 10000
}

class StoreScreenVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum Const {
        static let bacgraundImagename = "mainBackGraund"
    }
    
    private var collectionView: UICollectionView!

    let viewModel = StoreScreenViewModel()
    
    var isNeedScrollToDrums: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupCollectionView()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNeedScrollToDrums {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 3), at: .centeredVertically, animated: true)
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
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10 // Расстояние между ячейками
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Отступы для секций

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "StoreCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Заполняет весь экран
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }

    private func registerCells() {
        collectionView.register(BlockAddsCell.self, forCellWithReuseIdentifier: "BlockAddsCell")
        collectionView.register(BuyCoinsCell.self, forCellWithReuseIdentifier: "BuyCoinsCell")
        collectionView.register(DrumsCell.self, forCellWithReuseIdentifier: "DrumsCell")
        collectionView.register(FontsCell.self, forCellWithReuseIdentifier: "FontsCell")
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
    }
    
    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = viewModel.data[section].section
        switch sectionModel {
        case .blockAdds, .buyCoins, .fonts:
            return 1 // По одной ячейке в каждой из первых трех секций
        case .drums(let drums):
            return drums.count // Количество ячеек равно количеству drums в четвертой секции
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = viewModel.data[indexPath.section].section

        switch sectionModel {
        case .blockAdds(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlockAddsCell", for: indexPath) as? BlockAddsCell else {
                return UICollectionViewCell()
            }
            cell.viewController = self
            return cell

        case .buyCoins(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyCoinsCell", for: indexPath) as? BuyCoinsCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = model
            cell.viewController = self
            return cell

        case .drums(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrumsCell", for: indexPath) as? DrumsCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = model[indexPath.item]
            cell.viewController = self
            cell.scrollToTopHandler = {
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            return cell

        case .fonts(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontsCell", for: indexPath) as? FontsCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = model
            cell.viewController = self
            cell.scrollToTopHandler = {
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
  
            // Установим текст для заголовка секции
            let sectionModel = viewModel.data[indexPath.section].section
            switch sectionModel {
            case .blockAdds:
                headerView.titleLabel.text = "StoreScreen.BlockAdds".localized()
            case .buyCoins:
                headerView.titleLabel.text = "StoreScreen.BuyCoins".localized()
            case .drums:
                headerView.titleLabel.text = "StoreScreen.Drums".localized()
            case .fonts:
                headerView.titleLabel.text = "StoreScreen.Fonts".localized()
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = viewModel.data[indexPath.section].section

        switch sectionModel {
        case .blockAdds(let model):
            let width = collectionView.frame.width - 20 // Ширина ячейки с учетом отступов
            let height: CGFloat = 100 // Высота ячейки, можно задать по-другому
            return CGSize(width: width, height: height)

        case .buyCoins(let model):
            let width = collectionView.frame.width - 20 // Ширина ячейки с учетом отступов
            let height: CGFloat = 2 * collectionView.frame.width / 3 + 50 // Высота ячейки, можно задать по-другому
            return CGSize(width: width, height: height)

        case .drums(let model):
            let width = collectionView.frame.width - 20 // Ширина ячейки с учетом отступов
            let height: CGFloat = 2 * width / 3
            return CGSize(width: width, height: height + 40)

        case .fonts(let fonts):
            let width = collectionView.frame.width - 20 // Ширина ячейки с учетом отступов
            let height: CGFloat = 2 * collectionView.frame.width / 3 + 50 // Высота ячейки, можно задать по-другому
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60) // Высота заголовка
    }
}
