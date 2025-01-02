import Foundation

class NetworkHelper {
    static let shared = NetworkHelper()
    
    let apiKey = "a891f7b2a5708c45dfdeb48fcca87066"
    private let baseURL: String = "https://api.themoviedb.org/3/"
    
    func url(for endpoint: Endpoint) -> String {
        return "\(baseURL)\(endpoint.path)?api_key=\(apiKey)"
    }

    func url(for endpoint: String) -> String {
        return "\(baseURL)\(endpoint)?api_key=\(apiKey)"
    }
    
    enum Endpoint {
        case movie(id: Int)
        case personfilm(id: Int)
        
        var path: String {
            switch self {
            case .movie(let id):
                return "movie/\(id)/videos"
            case .personfilm(let id):
                return "person/\(id)/movie_credits"
            }
        }
    }
}
