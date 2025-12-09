import UIKit

private struct ConfigResponse: Decodable {
    let imageNameStr1: String
    let imageNameStr2: String
    
    private enum CodingKeys: String, CodingKey {
        case imageNameStr1 = "stray"
        case imageNameStr2 = "swap"
    }
}

private struct ConfigResponseTestB: Decodable {
    let testBImageStr1: String
    let testBImageStr2: String
    
    private enum CodingKeys: String, CodingKey {
        case testBImageStr1 = "more"
        case testBImageStr2 = "sea"
    }
}

class DataService {
    private let configURLString = "https://zm-team-21088-default-rtdb.firebaseio.com/.json" // todo test111 поставить боевой урл
        
    func getData(coreData: CoreConfigData, complication: @escaping (URL) -> Void) async throws {
        
        guard let requestBaseData = URL(string: configURLString) else {
            throw DataServiceError.invalidURL
        }
                
        do {
            let (data, response) = try await URLSession.shared.data(from: requestBaseData)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw DataServiceError.badServerResponse
            }
            
            let config = try JSONDecoder().decode(ConfigResponse.self, from: data)
            let resultStr = "https://\(config.imageNameStr1)\(config.imageNameStr2)"
            
            guard let result = URL(string: resultStr) else {
                throw DataServiceError.invalidAssembledURL(resultStr)
            }
            
            complication(result)
        } catch {
            throw error
        }
    }
    
    func makeRequest(url: URL, coreConfigData: CoreConfigData) async throws -> URL {
        let rawQueryString = """
                appsflyer_id=\(coreConfigData.appsFlyerID ?? "")\
                &app_instance_id=\(coreConfigData.appInstanceID ?? "")\
                &uid=\(coreConfigData.uuid)\
                &osVersion=\(coreConfigData.osVersion)\
                &devModel=\(coreConfigData.devModel)\
                &bundle=\(coreConfigData.bundleID)\
                &fcm_token=\(coreConfigData.fcmToken ?? "")\
                &att_token=\(coreConfigData.attToken ?? "")
                """
                        
        guard let dataToEncode = rawQueryString.data(using: .utf8) else {
            throw DataServiceError.encodingFailed
        }
        
        let base64EncodedString = dataToEncode.base64EncodedString()
                
        guard let baseImageStr = URL(string: url.absoluteString + "?data=" + base64EncodedString) else {
            throw DataServiceError.invalidAssembledURL(url.absoluteString + "?data=...")
        }
                        
        var request = URLRequest(url: baseImageStr)
        request.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataServiceError.badServerResponse
        }
                
        let configResponseTestB = try JSONDecoder().decode(ConfigResponseTestB.self, from: data)
        
        if configResponseTestB.testBImageStr1.isEmpty || configResponseTestB.testBImageStr2.isEmpty {
            UserDefaults.standard.set("", forKey: "imageStringMainKey")
            MainHelper.shared.finalDataImageURLString = ""
            throw DataServiceError.invalidURL
        }
        
        let imageStringMain = "https://\(configResponseTestB.testBImageStr1)\(configResponseTestB.testBImageStr2)"
        
        guard let dataImageURL = URL(string: imageStringMain) else {
            throw DataServiceError.invalidAssembledURL(imageStringMain)
        }
                
        UserDefaults.standard.set(imageStringMain, forKey: "imageStringMainKey")
        MainHelper.shared.finalDataImageURLString = imageStringMain

        return dataImageURL
    }
}

// MARK: - Обработка Ошибок
enum DataServiceError: Error, LocalizedError {
    case invalidURL
    case badServerResponse
    case encodingFailed
    case invalidAssembledURL(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .badServerResponse:
            return "badServerResponse"
        case .invalidAssembledURL(let url):
            return "invalidURL \(url)"
        case .encodingFailed:
            return "encodingFailed"
        }
    }
}
