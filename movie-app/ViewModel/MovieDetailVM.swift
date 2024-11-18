//
//  MovieDetailVM.swift
//  movie-app
//
//  Created by Emil Maharramov on 18.11.24.
//

import Foundation

class MovieDetailVM {
    
    var trendingMovieById: [Movie] = []
    var didUpdateMovie: (() -> Void)?
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    
    func loadMovie(id:Int) {
        
        let manager = HomeNetworkManager()
        
        manager.getTrendingMovieById(id: id) { response, error in
            if let error {
                self.error?(error)
                print(error)
            } else if let response {
                self.trendingMovieById = response
                self.success?()
            }
        }
    }
}
