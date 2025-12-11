import UIKit

struct LevelProgres: Codable {
    var isFinished: Bool = false
    var isError: Bool = false
    var isTime: Bool = false
}

class LevelProgreeHelper {
    private(set) var levelProgres: [LevelProgres] = []
    private(set) var extraLevelProgres: [LevelProgres] = []
    private(set) var manyLevelProgres: [LevelProgres] = []

    static let shared = LevelProgreeHelper()
    
    private let defaults = UserDefaults.standard
    private let levelProgresKey = "levelProgresKey"
    private let extraLevelProgresKey = "extraLevelProgresKey"
    private let manyLevelProgresKey = "manyLevelProgresKey"

    private init() {
        loadLevelProgres()
        loadExtraLevelProgres()
        loadManyLevelProgres()
        if levelProgres.isEmpty {
            levelProgres = (0...19).map { _ in LevelProgres() }
            saveLevelProgres()
        }
        if extraLevelProgres.isEmpty {
            extraLevelProgres = (0...49).map { _ in LevelProgres() }
            saveExtraLevelProgres()
        }
        if manyLevelProgres.isEmpty {
            manyLevelProgres = (0...49).map { _ in LevelProgres() }
            saveManyLevelProgres()
        }
    }
    
    func updateLevelProgres(with levelProgres: LevelProgres, at index: Int) {
        guard self.levelProgres.count > index else { return }
        
        self.levelProgres[index] = levelProgres
        saveLevelProgres()
        loadLevelProgres()
    }
    
    private func saveLevelProgres() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(levelProgres) {
            defaults.set(encoded, forKey: levelProgresKey)
        }
    }
    
    private func loadLevelProgres() {
        if let savedData = defaults.object(forKey: levelProgresKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedProgres = try? decoder.decode([LevelProgres].self, from: savedData) {
                levelProgres = loadedProgres
            }
        }
    }
    
    // MARK: - ExtraLevels

    func updateExtraLevelProgres(with levelProgres: LevelProgres, at index: Int) {
        guard self.extraLevelProgres.count > index else { return }
        
        self.extraLevelProgres[index] = levelProgres
        saveExtraLevelProgres()
        loadExtraLevelProgres()
    }
    
    private func saveExtraLevelProgres() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(extraLevelProgres) {
            defaults.set(encoded, forKey: extraLevelProgresKey)
        }
    }
    
    private func loadExtraLevelProgres() {
        if let savedData = defaults.object(forKey: extraLevelProgresKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedProgres = try? decoder.decode([LevelProgres].self, from: savedData) {
                extraLevelProgres = loadedProgres
            }
        }
    }
    
    // MARK: - ManyLevels
    
    func updateManyLevelProgres(with levelProgres: LevelProgres, at index: Int) {
        guard self.manyLevelProgres.count > index else { return }
        
        self.manyLevelProgres[index] = levelProgres
        saveManyLevelProgres()
        loadManyLevelProgres()
    }
    
    private func saveManyLevelProgres() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(manyLevelProgres) {
            defaults.set(encoded, forKey: manyLevelProgresKey)
        }
    }
    
    private func loadManyLevelProgres() {
        if let savedData = defaults.object(forKey: manyLevelProgresKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedProgres = try? decoder.decode([LevelProgres].self, from: savedData) {
                manyLevelProgres = loadedProgres
            }
        }
    }
    
    func saveManyLevels(_ isPayed: Bool) {
        UserDefaults.standard.set(isPayed, forKey: "ManyLevels")
    }
    
    func getManyLevels() -> Bool {
        return UserDefaults.standard.value(forKey: "ManyLevels") as? Bool ?? false
    }
}
