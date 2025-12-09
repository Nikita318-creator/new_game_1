//
//  MainCoinViewManager.swift
//  Baraban
//
//  Created by никита уваров on 8.09.24.
//

import UIKit
import SnapKit

class MainCoinViewManager {
    static let shared = MainCoinViewManager()
    
    private init() {
        setupMainCoinView()
    }
    
    private let mainCoinView = MainCoinView()
    
    private func setupMainCoinView() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.layoutIfNeeded()
        window.addSubview(mainCoinView)
        
        mainCoinView.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaLayoutGuide.snp.top).offset(2)
            make.trailing.equalTo(window.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.height.equalTo(50)
            make.width.equalTo(UIScreen.main.bounds.width / 2 - 10)
        }
        mainCoinView.updateCoinsCount()
    }
    
    func show() {
        mainCoinView.isHidden = false
    }
    
    func hide() {
        mainCoinView.isHidden = true
    }
}
