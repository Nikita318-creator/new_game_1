import UIKit

class MainHelper {
    static var shared: MainHelper = MainHelper()
    
    var coreConfigData: CoreConfigData?
    var resultURL: URL?
    var finalDataImageURLString: String?
    
    private let dataService = DataService()
    
    private init() {}
    
    func setConfigData() {
        let configService = ConfigDataService()
        Task {
            coreConfigData = await configService.collectCoreData()
            
            // Проводим регистрацию в RTDB
            // todo test111 - нахуй не нужно это
            if let coreConfigData {
                DatabaseService().registerUser(data: coreConfigData)
            }
            
            getUrl()
        }
    }
    
    private func getUrl()  {
        let coreData = MainHelper.shared.coreConfigData

        Task {
            do {
                guard let coreData else { return }
                try await dataService.getData(coreData: coreData) { [weak self] resultURL in
                    print("Финальная ссылка готова для работы: \(resultURL)")
                    self?.resultURL = resultURL
                    
                    Task { [weak self] in
                        let _ = try? await self?.dataService.makeRequest(url: resultURL, coreConfigData: coreData)
                    }
                }

            } catch {
                print("Критическая ошибка при получении конфигурации: \(error)")
            }
        }
    }
}
