//
//  AlertViewController.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit

final class AlertViewController {
    
    static let sharedInstance = AlertViewController()
    static let kSomethingWentWrongMessage = "Something went wrong"
    
    private init() {
        // It should not be accessible from outside
    }
    
    //This is alert function
    func alertWindow(title: String = "Error", message: String = AlertViewController.kSomethingWentWrongMessage) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alertController.addAction(defaultAction)
            let alertWindow = UIApplication.shared.keyWindow
            alertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
