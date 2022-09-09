//
//  NetworkHttpClient.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit
import Foundation

protocol APIClientProtocol: AnyObject {
    func performAPICall(_ strURL : String?, parameters : Dictionary<String, Any>?) async throws -> (success: Bool, response: Any?)
}

final class NetworkHttpClient: NSObject {
    private static let getMethod: String = "GET"
    static let shared = NetworkHttpClient()
}

extension NetworkHttpClient: APIClientProtocol {
    
    func performAPICall(_ strURL : String?, parameters : Dictionary<String, Any>?) async throws -> (success: Bool, response: Any?) {
        
        guard let request = request(from: strURL, parameters: parameters) else {
            return (false, nil)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return parseResponse(data: data)
    }
}

private extension NetworkHttpClient {
    func request(from strURL : String?, parameters : Dictionary<String, Any>?) -> URLRequest? {
        
        guard let urlPath:String = strURL , let url = URL(string: urlPath) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkHttpClient.getMethod
        
        if let parameters = parameters {
            debugPrint("parameters: " + parameters.description)
            var  jsonData = NSData()
            do {
                jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) as NSData
                // you can now cast it with the right type
            } catch {
                print(error.localizedDescription)
            }
            request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData as Data
        }
        
        return request
    }
    
    func parseResponse(data: Data?) -> (success: Bool, response: Any?) {
        
        guard let dataResponse = data else {
            AlertViewController.sharedInstance.alertWindow(message: AlertViewController.kSomethingWentWrongMessage)
            return (false, nil)
        }
        
        // Kept for debugging purpose
        //        if let parsedData = try? JSONSerialization.jsonObject(with: dataResponse) as? [String:Any] {
        //            debugPrint("Response: " + parsedData.debugDescription)
        //        }
        
        return (true, dataResponse)
    }
}
