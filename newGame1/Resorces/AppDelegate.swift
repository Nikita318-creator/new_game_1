import UIKit
import FirebaseMessaging
import FirebaseCore
import FirebaseInstallations
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1. Инициализация Firebase
        FirebaseApp.configure()
        
        // 2. Инициализация AppsFlyer SDK
        AppsFlyerLib.shared().appsFlyerDevKey = Const.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = Const.appleAppID
        AppsFlyerLib.shared().start() // Запуск AppsFlyer
        
        // 3. Установка делегата Messaging
        Messaging.messaging().delegate = self

        // 4. Запрос разрешения на уведомления (это нужно для получения APNs токена)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()

        return true
    }
    
    // --- Обработка Токенов APNs и FCM ---
    
    // Этот метод вызывается, когда Apple предоставляет APNs токен
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Передача APNs токена в Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // (Опционально) Обработка ошибки регистрации уведомлений
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

// Расширение для обработки FCM токена
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    // Этот метод вызывается Firebase, когда получен новый FCM токен
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("Firebase registration token received: \(token)")
            // ВАЖНО: Здесь вы можете сохранить полученный токен в локальном хранилище
            // или сразу же отправить его в Firebase Realtime Database
            
            // Пример сохранения токена для дальнейшего использования
            UserDefaults.standard.set(token, forKey: "fcm_token")
            
            // Если нужно сразу отправить в RTDB, потребуется дополнительный код
        }
    }
    
    // Обработка получения уведомлений на переднем плане (для RTDB не критично, но полезно)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }
}
