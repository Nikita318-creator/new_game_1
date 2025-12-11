import UIKit
import SnapKit

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
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: Const.bacgraundImagename)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func registerCells() {
        collectionView.register(DrumsCell.self, forCellWithReuseIdentifier: "DrumsCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
    }
    
    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = viewModel.data[section].section
        switch sectionModel {
        case .drums(let drums):
            return drums.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = viewModel.data[indexPath.section].section
        
        switch sectionModel {
        case .drums(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrumsCell", for: indexPath) as? DrumsCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = model[indexPath.item]
            cell.viewController = self
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
  
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
        case .drums:
            let horizontalInsets: CGFloat = 32
            let availableWidth = collectionView.frame.width - horizontalInsets
            
            let height: CGFloat = 280
            return CGSize(width: availableWidth, height: height)
            
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 56)
    }
}
