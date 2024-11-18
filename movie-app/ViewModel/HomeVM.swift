//
//  HomeVM.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//

import Foundation

class HomeVM {
    
    var trendingMovie: [Movie] = []
    var popularMovie: [Movie] = []
    var didUpdateMovie: (() -> Void)?
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    
    func loadMovie() {
        
        let manager = HomeNetworkManager()

        manager.getTrendingsMovie { items, errorString in
            if let errorString {
                self.error?(errorString)
            } else if let items {
                self.trendingMovie = items
                self.success?()
            }
        }
 
        manager.getPopularMovie { items, errorString in
            if let errorString {
                self.error?(errorString)
            } else if let items {
                self.popularMovie = items
                self.success?()
            }
        }
    }
}
