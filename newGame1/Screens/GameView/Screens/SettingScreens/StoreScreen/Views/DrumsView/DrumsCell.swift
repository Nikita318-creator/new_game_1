//
//  DrumsCell.swift
//  Baraban
//
//  Created by никита уваров on 6.09.24.
//

import UIKit
import SnapKit

class DrumsCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var collectionView: UICollectionView!
    private var stackView: UIStackView!
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.FontsName.mainFont.value.withSize(26)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.backgroundColor = .black.withAlphaComponent(0.7)
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    var viewModel: DrumsModel? {
        didSet {
            collectionView.reloadData()
            headerLabel.text = viewModel?.sectionTitle // Обновляем текст заголовка
        }
    }
    
    var viewController: UIViewController?
    var scrollToTopHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupHeaderLabel()
        setupCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentDrumHandle), name: Notification.Name("changeCurrentDrum"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        // Создаем UIStackView
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupHeaderLabel() {
        // Добавляем headerLabel в stackView
        stackView.addArrangedSubview(headerLabel)
        // Устанавливаем высоту заголовка
        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(50) // Установите желаемую высоту
        }
    }
    
    private func setupCollectionView() {
        // Настройка компоновки
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Создание UICollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        // Регистрация ячейки
        collectionView.register(DrumsOneCell.self, forCellWithReuseIdentifier: "DrumsOneCell")
        
        // Добавляем collectionView в stackView
        stackView.addArrangedSubview(collectionView)
        
        // Устанавливаем высоту collectionView через ограничение
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(100) // Устанавливаем высоту коллекции
        }
    }
    
    @objc private func changeCurrentDrumHandle() {
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.oneDrumsModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrumsOneCell", for: indexPath) as? DrumsOneCell,
            let data = viewModel?.oneDrumsModel[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        let title = PurchasedLogicHelper.shared.getDrumPurchased().contains(data.id) ? "StoreScreen.Buy.Coins.Avaliable".localized() : data.title
        cell.configure(image: data.image, title: title)
        cell.updateDidSelect(isSelect: PurchasedLogicHelper.shared.getCurrentDrumID() == data.id)

        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let data = viewModel?.oneDrumsModel[indexPath.item]
        else {
            return
        }
        
        if PurchasedLogicHelper.shared.getDrumPurchased().contains(data.id), let defaultBaraban = UIImage(named: "Baraban") {
            PurchasedLogicHelper.shared.saveCurrentDrum(data.image ?? defaultBaraban)
            PurchasedLogicHelper.shared.saveCurrentDrumID(data.id)
            NotificationCenter.default.post(name: Notification.Name("changeCurrentDrum"), object: nil)
        } else {
            buyTapped(data: data)
        }
    }
    
    private func buyTapped(data: OneDrumsModel) {
        // Создание и отображение алерта
        
        let title = data.cost == 0 ? "" : "StoreScreen.Buy.Drum".localized() + " \(data.cost) " + "StoreScreen.Buy.Coins.Text".localized()
        let message = data.cost == 0 ? "StoreScreen.Buy.Drum.StoryLine".localized() : "StoreScreen.Buy.Drum.Message".localized()
        
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
            title:  "StoreScreen.BlockAddsCell.confirm".localized(),
            style: .default,//.
            handler: { [weak self] _ in
                guard data.cost != 0 else { return }

                if CoinsHelper.shared.getSpecialCoins() >= data.cost {
                    PurchasedLogicHelper.shared.addDrumPurchased(purchas: data.id)
                    CoinsHelper.shared.saveSpecialCoins(CoinsHelper.shared.getSpecialCoins() - data.cost)
                    if let defaultBaraban = UIImage(named: "Baraban") {
                        PurchasedLogicHelper.shared.saveCurrentDrum(data.image ?? defaultBaraban)
                        PurchasedLogicHelper.shared.saveCurrentDrumID(data.id)
                        NotificationCenter.default.post(name: Notification.Name("changeCurrentDrum"), object: nil)
                    }
                } else {
                    self?.showAlertNotEnothMoney()
                }
            }))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlertNotEnothMoney() {
        let alert = UIAlertController(
            title: "StoreScreen.Buy.Coins.NotEnath.Title".localized(),
            message: "StoreScreen.Buy.Coins.NotEnath.Message".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title: "OK".localized(),
            style: .destructive,
            handler: { [weak self] _ in
                self?.scrollToTopHandler?()
            }))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
