import UIKit
import FirebaseMessaging
import FirebaseCore
import FirebaseInstallations
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        AppsFlyerLib.shared().appsFlyerDevKey = Const.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = Const.appleAppID
        AppsFlyerLib.shared().start()
        
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = []
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()

        let _ = MainHelper.shared
        
        return true
    }
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let dataImageURLString = UserDefaults.standard.string(forKey: "imageStringMainKey") {
            MainHelper.shared.finalDataImageString = dataImageURLString
            return
        }
        
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcm_token")
            MainHelper.shared.setConfigData()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[]])
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let linkString = userInfo["link"] as? String,
           let url = URL(string: linkString) {
            
            let scheme = url.scheme?.lowercased() ?? ""
            let internalSchemes: Set<String> = ["http", "https", "about", "srcdoc", "blob", "data", "javascript", "file"]
            
            if internalSchemes.contains(scheme) {
                
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            completionHandler(.newData)
            return
        }
        completionHandler(.noData)
    }
}
