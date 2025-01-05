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
    var popularPerson: [Actor] = []
    var popularPersonFilms: [Film] = [] 
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let manager = HomeNetworkManager()
    
    func getActorMovies(actorId: Int) {
        manager.getActorMovies(actorId: actorId) { [weak self] films, error in
                guard let self = self else { return }

              if let films = films {
                  self.popularPersonFilms = films
                  self.success?()
                }
            }
        }
    
    func loadMovie() {
        
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
        
        manager.getPopularActors { items, errorString in
            if let errorString {
                self.error?(errorString)
            } else if let items {
                self.popularPerson = items
                self.success?()
            }
        }
    }
}
