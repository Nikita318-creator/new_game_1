
import UIKit

struct MainCellModel {
    let image: UIImage
    let chapterName: String
}

enum ChapterNames {
    static let chapter1 = "chapter1.name".localized()
    static let chapter2 = "chapter2.name".localized()
    static let chapter3 = "chapter3.name".localized()
    static let chapter4 = "chapter4.name".localized()
    static let chapter5 = "chapter5.name".localized()
    static let chapter6 = "chapter6.name".localized()
}

class MainCellModels {
    var data: [MainCellModel] = [
        MainCellModel(image: UIImage(named: "MainCell1") ?? UIImage(), chapterName: ChapterNames.chapter1),
        MainCellModel(image: UIImage(named: "MainCell2") ?? UIImage(), chapterName: ChapterNames.chapter2),
        MainCellModel(image: UIImage(named: "MainCell3") ?? UIImage(), chapterName: ChapterNames.chapter3),
        MainCellModel(image: UIImage(named: "MainCell4") ?? UIImage(), chapterName: ChapterNames.chapter4),
        MainCellModel(image: UIImage(named: "MainCell5") ?? UIImage(), chapterName: ChapterNames.chapter5),
        MainCellModel(image: UIImage(named: "MainCell6") ?? UIImage(), chapterName: ChapterNames.chapter6),
    ]
}
