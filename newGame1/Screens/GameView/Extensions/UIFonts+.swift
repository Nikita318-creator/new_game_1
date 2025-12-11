import UIKit

extension UIFont {
    static var headlineFont: UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
    }
    
    static var bodyFont: UIFont {
        return UIFont(name: "HelveticaNeue", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    static var captionFont: UIFont {
        return UIFont(name: "HelveticaNeue-Italic", size: 14) ?? UIFont.italicSystemFont(ofSize: 14)
    }
    
    static var footnoteFont: UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .light)
    }
    
    // MARK: - Cost Fonts
    
    static var CostFont0: UIFont {
        return UIFont.FontsName.font0.value.withSize(30)
    }
    
    static var CostFont1: UIFont {
        return UIFont(name: "Impact", size: 40) ?? UIFont.systemFont(ofSize: 40)
    }
    
    static var CostFont2: UIFont {
        return UIFont(name: "Chalkduster", size: 34) ?? UIFont.systemFont(ofSize: 34)
    }
    
    static var CostFont3: UIFont {
        return UIFont(name: "Noteworthy", size: 34) ?? UIFont.systemFont(ofSize: 34)
    }
    
    static var CostFont4: UIFont {
        return UIFont(name: "Papyrus", size: 34) ?? UIFont.systemFont(ofSize: 34)
    }
    
    static var CostFont5: UIFont {
        return UIFont(name: "Zapfino", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    
}

extension UIFont {
    
    enum FontsName: CaseIterable {
        case costforfont
        case gameFont
        case simpleFont
        case mainFont
        case font1
        case font3
        case font0

        var value: UIFont {
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            let isEnglish = preferredLanguage.starts(with: "en")
            
            switch self {
            case .mainFont:
                let currentMainfont = PurchasedLogicHelper.shared.getCurrentFont() ?? (isEnglish ? UIFont(name: "KeltCapsFreehand", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont(name: "MarkerFelt-Wide", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold))
                return currentMainfont
                
            case .font0:
                return isEnglish ? UIFont(name: "KeltCapsFreehand", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont(name: "MarkerFelt-Wide", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
                
            case .simpleFont:
                return isEnglish ? UIFont(name: "NewYorkPlain", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
                
            case .costforfont:
                return isEnglish ? UIFont(name: "ChristmasScriptC", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
                
            case .gameFont:
                return isEnglish ? UIFont(name: "beermoney", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
                
            case .font1:
                return isEnglish ? UIFont(name: "Comfortaa-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
                
            case .font3:
                return isEnglish ? UIFont(name: "NautilusPompilius", size: 20) ?? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
            }
        }
    }
}



// UIFont(name: "Avenir-Heavy", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold) // - жирный
// UIFont(name: "MarkerFelt-Wide", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold) // - с лонч Скрина
//UIFont(name: "DINCondensed-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold) // - прижат
//UIFont(name: "Futura-CondensedMedium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium) // - палками

//UIFont(name: "DINAlternate-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
//UIFont(name: "Roboto-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
//UIFont(name: "Futura-CondensedExtraBold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
//UIFont(name: "HelveticaNeue-CondensedBlack", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .black)
