//
//  UIColor+hex.swift
//  Baraban
//
//  Created by никита уваров on 23.08.24.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        if hexSanitized.count != 6 {
            self.init(white: 0.5, alpha: 1.0) // возвращаем серый цвет, если формат неверный
            return
        }
        
        var rgb: UInt32 = 0
        Scanner(string: hexSanitized).scanHexInt32(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static var mainColor: UIColor {
        return UIColor(hex: "#000000") // Черный цвет
    }
    
    static var activeColor: UIColor {
        return UIColor(hex: "#FFFFFF") // Белый цвет
    }
    
    static var inactiveColor: UIColor {
        return UIColor(hex: "#B0B0B0") // Светло-серый цвет
    }
    
    static var backgroundColor: UIColor {
        return UIColor(hex: "#F5F5F5") // Очень светло-серый цвет
    }
    
    static var textColor: UIColor {
        return UIColor(hex: "#333333") // Темно-серый цвет
    }
}
