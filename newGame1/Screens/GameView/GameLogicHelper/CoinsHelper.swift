//
//  CoinsHelper.swift
//  Baraban
//
//  Created by никита уваров on 29.08.24.
//

import Foundation
import UIKit

class CoinsHelper {
    
    static let shared = CoinsHelper()
    
    private let lastVisitDateKey = "lastVisitDate"
    private let consecutiveDaysKey = "consecutiveDays"
    private let userDefaults = UserDefaults.standard
    
    var currentMultiplireForXCoin = 1

    private init() {}
    
    func updateSpecialCoins() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Получите дату последнего визита
        guard let lastVisitDate = userDefaults.object(forKey: lastVisitDateKey) as? Date else {
            // Если это первый визит, установите дату последнего визита и начислите 1 монету
            userDefaults.set(currentDate, forKey: lastVisitDateKey)
            userDefaults.set(1, forKey: consecutiveDaysKey)
            return 1
        }
        
        // Рассчитайте разницу в днях
        let dayComponents = calendar.dateComponents([.day], from: lastVisitDate, to: currentDate)
        
        guard let daysPassed = dayComponents.day else {
            // Если не удалось рассчитать разницу, ничего не делаем
            return 0
        }
        
//        let daysPassed = 1
        
        if daysPassed < 0 {
            userDefaults.set(currentDate, forKey: lastVisitDateKey)
            userDefaults.set(1, forKey: consecutiveDaysKey)
            showAlertForTimeCheating()
            return 0
        } else if daysPassed == 0 {
            // Если зашел повторно в тот же день, не начисляем монеты
            return 0
        } else if daysPassed == 1 {
            // Если прошел 1 день, увеличиваем счетчик дней и начисляем монеты
            let consecutiveDays = userDefaults.integer(forKey: consecutiveDaysKey) + 1 // - протестить а то кол-во дней 24 вернул
            userDefaults.set(currentDate, forKey: lastVisitDateKey)
            userDefaults.set(consecutiveDays, forKey: consecutiveDaysKey)
            let newCoins = min(consecutiveDays, 5) // Максимум 5 монет
            return newCoins
        } else {
            // Если пропустил день или больше, сбрасываем счетчик дней и начисляем 1 монету
            userDefaults.set(currentDate, forKey: lastVisitDateKey)
            userDefaults.set(1, forKey: consecutiveDaysKey)
            return 1
        }
    }

    // Функция для отображения alert
    func showAlertForTimeCheating() {
        let alert = UIAlertController(title: "Coins.TimeError.Title".localized(), message: "Coins.TimeError.Message".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        
        // Найдите текущий видимый ViewController, чтобы показать alert
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveRegularCoins(_ count: Int) {
        userDefaults.set(count, forKey: "RegularCoins")
        NotificationCenter.default.post(name: Notification.Name("saveRegularCoins"), object: nil)
    }
    
    func getRegularCoins() -> Int {
        return userDefaults.integer(forKey: "RegularCoins")
    }
    
    func saveSpecialCoins(_ count: Int) {
        userDefaults.set(count, forKey: "SpecialCoins")
        NotificationCenter.default.post(name: Notification.Name("saveSpecialCoins"), object: nil)
    }
    
    func getSpecialCoins() -> Int {
        return userDefaults.integer(forKey: "SpecialCoins")
    }
}
