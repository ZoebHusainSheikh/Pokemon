//
//  NetworkHttpClient.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit
import Foundation

typealias CompletionHandler = (_ success: Bool, _ response: Any?) -> Void
typealias successBlock = (_ response: Data) -> Void
typealias failureBlock = (_ response: Error?) -> Void

protocol APIClientProtocol: AnyObject {
    func performAPICall(_ strURL : String?, parameters : Dictionary<String, Any>?, success:@escaping successBlock, failure:@escaping failureBlock)
}

class NetworkHttpClient: NSObject {
    private static let getMethod: String = "GET"
    static let sharedInstance = NetworkHttpClient()
}

extension NetworkHttpClient: APIClientProtocol {
    
    func performAPICall(_ strURL : String?, parameters : Dictionary<String, Any>?, success:@escaping successBlock, failure:@escaping failureBlock) {
        if let urlPath:String = strURL {
            
            guard let url = URL(string: urlPath) else { return }
            
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
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.parseResponse(success: success, failure: failure, data: data, response: response, error: error)
            }
            task.resume()
        }
    }
}

private extension NetworkHttpClient {
    
    func parseResponse(success: successBlock, failure: failureBlock, data: Data?, response: URLResponse?, error: Error?) {
        guard let dataResponse = data,
              error == nil else {
                  debugPrint(error?.localizedDescription ?? "Response Error")
                  failure(error)
                  AlertViewController.sharedInstance.alertWindow(message: error?.localizedDescription ?? AlertViewController.kSomethingWentWrongMessage)
                  return
              }
        
        // Kept for debugging purpose
        //        if let parsedData = try? JSONSerialization.jsonObject(with: dataResponse) as? [String:Any] {
        //            debugPrint("Response: " + parsedData.debugDescription)
        //        }
        
        success(dataResponse)
    }
    
}
