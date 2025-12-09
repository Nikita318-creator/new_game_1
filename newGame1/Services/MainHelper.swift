import UIKit

class MainHelper {
    static var shared: MainHelper = MainHelper()
    
    var coreConfigData: CoreConfigData?
    var resultImageStr: URL?
    var finalDataImageURLString: String?
    
    private let dataService = DataService()
    
    private init() {}
    
    func setConfigData() {
        let configService = ConfigDataService()
        Task {
            coreConfigData = await configService.collectCoreData()
            getUrl()
        }
    }
    
    private func getUrl()  {
        let coreData = MainHelper.shared.coreConfigData

        Task {
            do {
                guard let coreData else { return }
                try await dataService.getData(coreData: coreData) { [weak self] resultImageStr in
                    self?.resultImageStr = resultImageStr
                    
                    Task { [weak self] in
                        do {
                            let _ = try await self?.dataService.makeRequest(url: resultImageStr, coreConfigData: coreData)
                        } catch {
                            MainHelper.shared.finalDataImageURLString = ""
                        }
                    }
                }
            }  catch {
                MainHelper.shared.finalDataImageURLString = ""
            }
        }
    }
}
