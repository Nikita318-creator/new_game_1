
import UIKit

enum StoreData {
    static let product100CoinsPackIdentifier = "coins.pack.100"
    static let product500CoinsPackIdentifier = "coins.pack.500"
    static let product1000CoinsPackIdentifier = "coins.pack.1000"
    static let product10000CoinsPackIdentifier = "coins.pack.10000"
}

struct BlockAddsModel {
    var text: String
}

struct OneCoinModel {
    var image: UIImage?
    var title: String // cost String
    var subtitle: String // coinCount string
    var cost: Double
    var coinCount: Int
    var productIdentifier: String // TODO: - ID продукта в AppStore
}

struct OneFontModel {
    var id: Int
    var cost: Int
    var font: UIFont
}

struct OneDrumsModel {
    var id: Int
    var image: UIImage?
    var title: String // cost String
    var cost: Int
}

struct BuyCoinsModel {
    var oneCoinModel: [OneCoinModel]
}

struct DrumsModel {
    var sectionTitle: String
    var oneDrumsModel: [OneDrumsModel]
}

struct FontsModel {
    var oneFontModel: [OneFontModel]
}

enum StoreSectionModel {
    case blockAdds(BlockAddsModel)
    case buyCoins(BuyCoinsModel)
    case drums([DrumsModel])
    case fonts(FontsModel)
}

struct StoreScreenModel {
    var section: StoreSectionModel
}

class StoreScreenViewModel {
    var data: [StoreScreenModel] = []
            
    let drumsData1 = DrumsModel(
        sectionTitle: "StoreScreen.Drums.section1".localized(),
        oneDrumsModel: [
            OneDrumsModel(
                id: 1,
                image: UIImage(named: "Baraban20"),
                title: "StoreScreen.Buy.Coins.NotAvaliable".localized(),
                cost: 0
            ),
            OneDrumsModel(
                id: 2,
                image: UIImage(named: "Baraban7"),
                title: "StoreScreen.Buy.Coins.NotAvaliable".localized(),
                cost: 0
            ),
            OneDrumsModel(
                id: 3,
                image: UIImage(named: "Baraban8"),
                title: "StoreScreen.Buy.Coins.NotAvaliable".localized(),
                cost: 0
            ),
            OneDrumsModel(
                id: 4,
                image: UIImage(named: "Baraban9"),
                title: "StoreScreen.Buy.Coins.NotAvaliable".localized(),
                cost: 0
            ),
            OneDrumsModel(
                id: 5,
                image: UIImage(named: "Baraban10"),
                title: "StoreScreen.Buy.Coins.NotAvaliable".localized(),
                cost: 0
            ),
        ]
    )
    
    let drumsData2 = DrumsModel(
        sectionTitle: "StoreScreen.Drums.section2".localized(),
        oneDrumsModel: [
            OneDrumsModel(
                id: 6,
                image: UIImage(named: "Baraban1"),
                title: "500",
                cost: 500
            ),
            OneDrumsModel(
                id: 7,
                image: UIImage(named: "Baraban2"),
                title: "500",
                cost: 500
            ),
            OneDrumsModel(
                id: 8,
                image: UIImage(named: "Baraban3"),
                title: "500",
                cost: 500
            ),
            OneDrumsModel(
                id: 9,
                image: UIImage(named: "Baraban4"),
                title: "500",
                cost: 500
            ),
            OneDrumsModel(
                id: 29,
                image: UIImage(named: "Baraban5"),
                title: "500",
                cost: 500
            ),
            OneDrumsModel(
                id: 12,
                image: UIImage(named: "Baraban6"),
                title: "500",
                cost: 500
            )
        ]
    )
    
    let drumsData3 = DrumsModel(
        sectionTitle: "StoreScreen.Drums.section3".localized(),
        oneDrumsModel: [
            OneDrumsModel(
                id: 10,
                image: UIImage(named: "Baraban11"),
                title: "50",
                cost: 50
            ),
            OneDrumsModel(
                id: 11,
                image: UIImage(named: "Baraban12"),
                title: "50",
                cost: 50
            ),
        ]
    )
    
    let drumsData4 = DrumsModel(
        sectionTitle: "StoreScreen.Drums.section4".localized(),
        oneDrumsModel: [
            OneDrumsModel(
                id: 13,
                image: UIImage(named: "Baraban13"),
                title: "100",
                cost: 100
            ),
            OneDrumsModel(
                id: 14,
                image: UIImage(named: "Baraban14"),
                title: "150",
                cost: 150
            ),
            OneDrumsModel(
                id: 15,
                image: UIImage(named: "Baraban15"),
                title: "200",
                cost: 200
            ),
        ]
    )
    
    let drumsData5 = DrumsModel(
        sectionTitle: "StoreScreen.Drums.section5".localized(),
        oneDrumsModel: [
            OneDrumsModel(
                id: 16,
                image: UIImage(named: "Baraban16"),
                title: "200",
                cost: 200
            ),
            OneDrumsModel(
                id: 17,
                image: UIImage(named: "Baraban17"),
                title: "200",
                cost: 200
            ),
            OneDrumsModel(
                id: 18,
                image: UIImage(named: "Baraban18"),
                title: "200",
                cost: 200
            ),
            OneDrumsModel(
                id: 19,
                image: UIImage(named: "Baraban23"),
                title: "200",
                cost: 200
            )
        ]
    )
    
    let drumsData6 = DrumsModel(
        sectionTitle: "StoreScreen.Drums.section6".localized(),
        oneDrumsModel: [
            OneDrumsModel(
                id: 20,
                image: UIImage(named: "Baraban19"),
                title: "1 000",
                cost: 1000
            ),
            OneDrumsModel(
                id: 21,
                image: UIImage(named: "Baraban20"),
                title: "500",
                cost: 500
            ),
            OneDrumsModel(
                id: 22,
                image: UIImage(named: "Baraban21"),
                title: "400",
                cost: 400
            )
        ]
    )
    
    init() {
        PurchasedLogicHelper.shared.addDrumPurchased(purchas: drumsData1.oneDrumsModel[0].id) 
        if PurchasedLogicHelper.shared.getCurrentDrumID() == 0 {
            PurchasedLogicHelper.shared.saveCurrentDrumID(1)
        }
        if PurchasedLogicHelper.shared.getCurrentFontID() == 0 {
            PurchasedLogicHelper.shared.saveCurrentFontID(23)
        }
        
        data = [            
            StoreScreenModel(section: .drums([drumsData1, drumsData2, drumsData3, drumsData4, drumsData5, drumsData6]))
        ]
    }
}
