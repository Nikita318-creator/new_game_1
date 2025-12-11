import UIKit

class GameLogicHelper {
    
    var currentLevel = 1
    var currentChapter = 1
    var currentExtraLevel = 1
    var currentManyLevel = 1

    var isGamefirstOpend = true
    
    static var shared = GameLogicHelper()
    
    private init() {
        if getFinishedChapters().isEmpty {
            saveFinishedChapters([1])
        }
    }
    
    func saveFinishedChapters(_ chapters: [Int]) {
        UserDefaults.standard.set(Array(Set(chapters)), forKey: "finishedChapters")
    }
    
    func getFinishedChapters() -> [Int] {
        return UserDefaults.standard.array(forKey: "finishedChapters") as? [Int] ?? []
    }
    
    func saveFinishedLevel(_ levels: [Int]) {
        UserDefaults.standard.set(Array(Set(levels)), forKey: "finishedLevel")
    }
    
    func getFinishedLevel() -> [Int] {
        return UserDefaults.standard.array(forKey: "finishedLevel") as? [Int] ?? []
    }
    
    // MARK: - ManyLevels

    func saveFinishedExtraLevel(_ levels: [Int]) {
        UserDefaults.standard.set(Array(Set(levels)), forKey: "FinishedExtra")
    }
    
    func getFinishedExtraLevel() -> [Int] {
        return UserDefaults.standard.array(forKey: "FinishedExtra") as? [Int] ?? []
    }
    
    // MARK: - ExtraLevel
    
    func saveFinishedManyLevel(_ levels: [Int]) {
        UserDefaults.standard.set(Array(Set(levels)), forKey: "FinishedManyLevel")
    }
    
    func getFinishedManyLevel() -> [Int] {
        return UserDefaults.standard.array(forKey: "FinishedManyLevel") as? [Int] ?? []
    }
    
    // MARK: - App Rate

    func saveRateApp(_ isRate: Bool) {
        UserDefaults.standard.set(isRate, forKey: "RateApp")
    }
    
    func getRateApp() -> Bool {
        return UserDefaults.standard.value(forKey: "RateApp") as? Bool ?? false
    }
    
    // MARK: - Game Lesson

    func saveGameLesson(_ isComplited: Bool) {
        UserDefaults.standard.set(isComplited, forKey: "GameLesson")
    }
    
    func getGameLesson() -> Bool {
        return UserDefaults.standard.value(forKey: "GameLesson") as? Bool ?? false
    }
    
    // MARK: - Onbordin
    
    func saveMainonbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Mainonbording")
    }
    
    func getMainonbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Mainonbording") as? Bool ?? false
    }
    
    func saveChapter1onbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter1onbording")
    }
    
    func getChapter1onbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter1onbording") as? Bool ?? false
    }
    
    func saveChapter1Fonbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter1Fonbording")
    }
    
    func getChapter1Fonbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter1Fonbording") as? Bool ?? false
    }
    
    func saveChapter2onbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter2onbording")
    }
    
    func getChapter2onbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter2onbording") as? Bool ?? false
    }
    
    func saveChapter2Fonbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter2Fonbording")
    }
    
    func getChapter2Fonbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter2Fonbording") as? Bool ?? false
    }
    
    func saveChapter3onbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter3onbording")
    }
    
    func getChapter3onbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter3onbording") as? Bool ?? false
    }
    
    func saveChapter3Fonbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter3Fonbording")
    }
    
    func getChapter3Fonbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter3Fonbording") as? Bool ?? false
    }
    
    func saveChapter4onbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter4onbording")
    }
    
    func getChapter4onbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter4onbording") as? Bool ?? false
    }
    
    func saveChapter4Fonbording(_ isSeen: Bool) {
        UserDefaults.standard.set(isSeen, forKey: "Chapter4Fonbording")
    }
    
    func getChapter4Fonbording() -> Bool {
        return UserDefaults.standard.value(forKey: "Chapter4Fonbording") as? Bool ?? false
    }
}
