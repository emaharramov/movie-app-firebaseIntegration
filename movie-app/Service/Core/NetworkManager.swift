//
//  NetworkManager.swift
//  movie-app
//
//  Created by Emil Maharramov on 01.01.25.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func request<T: Codable>(model: T.Type,
                             url: String,
                             method: HTTPMethod = .get,
                             completion: @escaping (T?, String?) -> Void) {
        AF.request(url, method: method).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
