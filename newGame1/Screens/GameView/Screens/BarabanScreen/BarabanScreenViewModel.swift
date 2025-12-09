//
//  BarabanScreenViewModel.swift
//  Baraban
//
//  Created by никита уваров on 24.08.24.
//

import UIKit

enum GameMod {
    case storyline
    case freeFall
    case manyLevels
}

struct BarabanLevelModel {
    let keyWord: String
    let question: String
}

class BarabanScreenViewModel: BaseCellViewModel {
    var gameMod = GameMod.storyline

    var data: [BarabanLevelModel] {
        var gameData: [BarabanLevelModel] = []
        
        switch gameMod {
        case .storyline:
            gameData = LevelsData().data
        case .freeFall:
            gameData = LevelsData().freefallData
        case .manyLevels:
            gameData = LevelsData().manyData
        }
        
        return gameData
    }
}
