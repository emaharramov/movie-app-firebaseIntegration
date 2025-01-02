//
//  HomeNetworkManager.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//
//

import Foundation

class HomeNetworkManager {
    
    func getPopularMovie(completion: @escaping ([Movie]?, String?) -> Void) {
        
        let endpoint = HomeEndPoint.popular.path
        let url = NetworkHelper.shared.url(for: endpoint)
        
        NetworkManager.shared.request(model: Response.self,
                                      url: url,
                                      method: .get) { data, error in
            completion(data?.results, error)
        }
    }
    
    
    func getTrendingsMovie(completion: @escaping ([Movie]?, String?) -> Void) {
        
        let endpoint = HomeEndPoint.trending.path
        let url = NetworkHelper.shared.url(for: endpoint)

        NetworkManager.shared.request(model: Response.self,
                                      url: url,
                                      method: .get) { data, error in
            completion(data?.results, error)
        }
        
    }
    
    func getActorMovies(actorId: Int, completion: @escaping ([Film]?, String?) -> Void) {
        let url = NetworkHelper.shared.url(for: .personfilm(id: actorId))
        
        NetworkManager.shared.request(model: ActorMoviesResponse.self,
                                      url: url,
                                      method: .get) { data, error in
            completion(data?.cast, error)
        }
    }
    
    func getTrendingMovieById(id: Int, completion: @escaping ([Movie]?, String?) -> Void) {
        
        let url = NetworkHelper.shared.url(for: .movie(id: id))
        
        NetworkManager.shared.request(model: Response.self,
                                      url: url,
                                      method: .get) { data, error in
            completion(data?.results, error)
        }

    }
    
    func getPopularActors(completion: @escaping ([Actor]?, String?) -> Void) {
        let endpoint = HomeEndPoint.person.path
        let url = NetworkHelper.shared.url(for: endpoint)
        
        NetworkManager.shared.request(model: ActorResponse.self,
                                      url: url,
                                      method: .get) { data, error in
            completion(data?.results, error)
        }
    }
    
}
