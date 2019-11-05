//
//  AlertHelper.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import UIKit

class AlertHelper {
    
    class func showAlert(controller: UIViewController, title: String, message: String, actionTitle: String, action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: title, style: .default, handler: action)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
}
