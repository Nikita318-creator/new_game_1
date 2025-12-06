import FirebaseDatabase

class DatabaseService {
    let databaseRef = Database.database().reference()
    
    func registerUser(data: CoreConfigData) {
        // Мы используем сгенерированный вами uuid как уникальный ключ для пользователя в RTDB
        let userRef = databaseRef.child("users").child(data.uuid)
        
        let userData: [String: Any?] = [
            "uuid": data.uuid,
            "appsflyer_id": data.appsFlyerID,
            "appinstanceid": data.appInstanceID,
            "fcm_token": data.fcmToken,
            "att_token": data.attToken,
            "osVersion": data.osVersion,
            "devModel": data.devModel,
            "bundleID": data.bundleID,
            "last_login": ServerValue.timestamp()
        ]
        
        // Запись данных в базу
        userRef.setValue(userData) { error, _ in
            if let error = error {
                print("Error saving user data to RTDB: \(error.localizedDescription)")
            } else {
                print("User data successfully registered in Firebase RTDB under UUID: \(data.uuid)")
            }
        }
    }
}
