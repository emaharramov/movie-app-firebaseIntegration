//
//  ProgressHUDLoader.swift
//  movie-app
//
//  Created by Emil Maharramov on 05.01.25.
//

import UIKit
import ProgressHUD

extension UIViewController {
    
    func showLoading() {
        ProgressHUD.animationType = .circleBarSpinFade
        ProgressHUD.colorAnimation = .systemGreen
        ProgressHUD.animate()
    }
    func hideLoading() {
        ProgressHUD.dismiss()
    }

    func showAlert(title: String, message: String, isError: Bool = false) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         
         let actionTitle = isError ? "Retry" : "OK"
         let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
         
         alert.addAction(action)
         
         if isError {
             alert.view.tintColor = .red
         }
         
         self.present(alert, animated: true, completion: nil)
     }
    
}
