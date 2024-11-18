//
//  HomeNetworkManager.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//
//

import Foundation
import Alamofire

class HomeNetworkManager {
    
    func getPopularMovie(completion: @escaping ([Movie]?, String?) -> Void) {
        
        let url = NetworkHelper.shared.url(for: .popular)

        AF.request(url, method: .get).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let responseData):
                completion(responseData.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    func getTrendingsMovie(completion: @escaping ([Movie]?, String?) -> Void) {
        
        let url = NetworkHelper.shared.url(for: .trending)

        AF.request(url, method: .get).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let responseData):
                completion(responseData.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getTrendingMovieById(id: Int, completion: @escaping ([Movie]?, String?) -> Void) {
        
        let url = NetworkHelper.shared.url(for: .movie(id: id))

        AF.request(url, method: .get).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let responseData):
                completion(responseData.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
}

      
