//
//  FontsCell.swift
//  Baraban
//
//  Created by никита уваров on 6.09.24.
//


import UIKit
import SnapKit

class FontsCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var stackView: UIStackView!
    
    var viewModel: FontsModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var viewController: UIViewController?
    var scrollToTopHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentFontHandle), name: Notification.Name("changeCurrentFont"), object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        // Создание UIStackView
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10) // Отступы для stackView
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
        collectionView.register(FontsOneCell.self, forCellWithReuseIdentifier: "FontsOneCell")
        
        // Добавляем collectionView в stackView
        stackView.addArrangedSubview(collectionView)
        
        // Устанавливаем высоту collectionView через ограничение
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Фиксированная высота для вложенной коллекции
        }
    }

    @objc private func changeCurrentFontHandle() {
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.oneFontModel.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontsOneCell", for: indexPath) as? FontsOneCell,
            let data = viewModel?.oneFontModel[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        let cost = PurchasedLogicHelper.shared.getFontPurchased().contains(data.id) || data.cost == 0 ? "StoreScreen.Buy.Coins.Avaliable".localized() : "\(data.cost)"
        cell.configure(cost: cost, font: data.font)
        cell.updateDidSelect(isSelect: PurchasedLogicHelper.shared.getCurrentFontID() == data.id)

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 2 * collectionView.frame.height / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let data = viewModel?.oneFontModel[indexPath.item]
        else {
            return
        }
        
        if PurchasedLogicHelper.shared.getFontPurchased().contains(data.id) || data.cost == 0 {
            PurchasedLogicHelper.shared.saveCurrentFont(data.font)
            PurchasedLogicHelper.shared.saveCurrentFontID(data.id)
            NotificationCenter.default.post(name: Notification.Name("changeCurrentFont"), object: nil)
        } else {
            buyTapped(data: data)
        }
    }
    
    private func buyTapped(data: OneFontModel) {
        // Создание и отображение алерта
        let alert = UIAlertController(
            title: "StoreScreen.Buy.Font".localized() + " \(data.cost)",
            message: "StoreScreen.Buy.Font.Message".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title:  "StoreScreen.BlockAddsCell.confirm".localized(),
            style: .destructive,
            handler: { [weak self] _ in
              
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
