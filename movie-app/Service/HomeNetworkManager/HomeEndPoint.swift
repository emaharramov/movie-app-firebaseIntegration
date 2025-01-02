//
//  HomeEndPoint.swift
//  movie-app
//
//  Created by Emil Maharramov on 01.01.25.
//

import Foundation

enum HomeEndPoint {
    case popular
    case trending
    case person

    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .trending:
            return "trending/movie/day"
        case .person:
            return "person/popular"
        }
    }
}

