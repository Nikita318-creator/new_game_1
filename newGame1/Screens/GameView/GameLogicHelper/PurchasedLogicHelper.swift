import UIKit

class PurchasedLogicHelper {
    
    static var shared = PurchasedLogicHelper()
    
    private init() {

    }
    
    // MARK: - Drums
    
    func saveNewDrumAvailable(_ isPayed: Bool) {
        UserDefaults.standard.set(isPayed, forKey: "NewDrumAvailable")
    }
    
    func getNewDrumAvailable() -> Bool {
        return UserDefaults.standard.value(forKey: "NewDrumAvailable") as? Bool ?? false
    }
    
    func addDrumPurchased(purchas: Int) {
        var newPurchases = getDrumPurchased()
        if !newPurchases.contains(purchas) && purchas <= 5 && purchas > 1 { // если разблокировался сюжетный барабан - показываем алерт
            saveNewDrumAvailable(true)
        }
        newPurchases.append(purchas)
        saveDrumPurchased(newPurchases)
    }
    
    func saveDrumPurchased(_ purchases: [Int]) {
        UserDefaults.standard.set(Array(Set(purchases)), forKey: "DrumPurchased")
    }
    
    func getDrumPurchased() -> [Int] {
        return UserDefaults.standard.array(forKey: "DrumPurchased") as? [Int] ?? []
    }
    
    func saveCurrentDrum(_ image: UIImage) {
        // Преобразуем изображение в Data (например, в PNG формат)
        if let imageData = image.pngData() {
            UserDefaults.standard.set(imageData, forKey: "CurrentDrum")
        }
    }
    
    func getCurrentDrum() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "CurrentDrum") {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func saveCurrentDrumID(_ id: Int) {
        UserDefaults.standard.set(id, forKey: "CurrentDrumID")
    }
    
    func getCurrentDrumID() -> Int {
        return UserDefaults.standard.integer(forKey: "CurrentDrumID")
    }
    
    // MARK: - Fonts
    
    func addFontPurchased(purchas: Int) {
        var newPurchases = getFontPurchased()
        newPurchases.append(purchas)
        saveFontPurchased(newPurchases)
    }
    
    func saveFontPurchased(_ purchases: [Int]) {
        UserDefaults.standard.set(Array(Set(purchases)), forKey: "FontPurchased")
    }
    
    func getFontPurchased() -> [Int] {
        return UserDefaults.standard.array(forKey: "FontPurchased") as? [Int] ?? []
    }
    
    func saveCurrentFont(_ font: UIFont) {
        // Сохраняем название шрифта и размер
        let fontName = font.fontName
        let fontSize = font.pointSize
        UserDefaults.standard.set(fontName, forKey: "CurrentFontName")
        UserDefaults.standard.set(fontSize, forKey: "CurrentFontSize")
    }
    
    func getCurrentFont() -> UIFont? {
        if let fontName = UserDefaults.standard.string(forKey: "CurrentFontName"),
           let fontSize = UserDefaults.standard.value(forKey: "CurrentFontSize") as? CGFloat {
            return UIFont(name: fontName, size: fontSize)
        }
        return nil
    }
    
    func saveCurrentFontID(_ id: Int) {
        UserDefaults.standard.set(id, forKey: "CurrentFontID")
    }
    
    func getCurrentFontID() -> Int {
        return UserDefaults.standard.integer(forKey: "CurrentFontID")
    }
    
    // MARK: - Adds
    
    func saveShowAdds(_ isPayed: Bool) {
        UserDefaults.standard.set(isPayed, forKey: "ShowAdds")
    }
    
    func getShowAdds() -> Bool {
        return UserDefaults.standard.value(forKey: "ShowAdds") as? Bool ?? false
    }
}
