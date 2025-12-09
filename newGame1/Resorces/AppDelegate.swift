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
            MainHelper.shared.finalDataImageURLString = dataImageURLString
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
