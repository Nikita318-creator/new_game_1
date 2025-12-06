import UIKit
import AdServices
import AppsFlyerLib
import FirebaseInstallations

struct CoreConfigData {
    let attToken: String?
    let appsFlyerID: String?
    let appInstanceID: String?
    let uuid: String
    let osVersion: String
    let devModel: String
    let bundleID: String
    var fcmToken: String?
}

class ConfigDataService {
    
    // MARK: - Вспомогательный метод для devModel
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let deviceModel = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
        return deviceModel
    }
    
    // MARK: - Основной метод сбора данных
    func collectCoreData() async -> CoreConfigData {
        
        // 1. Сбор att_token (асинхронный вызов)
        let attToken = try? AAAttribution.attributionToken()

        // 2. Сбор uuid (самостоятельная генерация в v4, lowercase)
        let deviceUUID = UUID().uuidString.lowercased()

        // 3. Сбор osVersion
        let osVersion = UIDevice.current.systemVersion
        
        // 4. Сбор devModel (использование вспомогательного метода)
        let devModel = getDeviceModel()

        // 5. Сбор bundle ID
        let bundleID = Bundle.main.bundleIdentifier ?? "com.unknown.app"

        // 6. Сбор appsFlyerID (AppsFlyer должен быть инициализирован в AppDelegate)
        let appsFlyerID = AppsFlyerLib.shared().getAppsFlyerUID()

        // 7. Сбор appinstanceid (Firebase Installation ID)
        let appInstanceID = try? await Installations.installations().installationID()
        
        // 8. Сбор fcmToken (берем из локального хранилища, куда он был сохранен в AppDelegate)
        let fcmToken = UserDefaults.standard.string(forKey: "fcm_token")
        
        //

        print("""
            --- Core Data Collected ---
            attToken: \(attToken ?? "N/A")
            appsFlyerID: \(appsFlyerID)
            appInstanceID: \(appInstanceID ?? "N/A")
            uuid: \(deviceUUID)
            osVersion: \(osVersion)
            devModel: \(devModel)
            bundleID: \(bundleID)
            fcmToken: \(fcmToken ?? "N/A - Check AppDelegate")
            ---------------------------
            """)
        
        return CoreConfigData(
            attToken: attToken,
            appsFlyerID: appsFlyerID,
            appInstanceID: appInstanceID,
            uuid: deviceUUID,
            osVersion: osVersion,
            devModel: devModel,
            bundleID: bundleID,
            fcmToken: fcmToken
        )
    }
}
