//
//  ImageViewExtension.swift
//  movie-app
//
//  Created by Emil Maharramov on 29.11.24.
//

import UIKit
import Kingfisher

extension UIImageView {
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    func setImage(from path: String?, placeholder: String = "default_poster") {
        guard let path = path, !path.isEmpty else {
            self.image = UIImage(named: placeholder)
            return
        }
        
        let fullPath = UIImageView.imageBaseURL + path
        guard let url = URL(string: fullPath) else {
            self.image = UIImage(named: placeholder)
            return
        }
        
        self.kf.setImage(with: url, placeholder: UIImage(named: placeholder))
    }
}
