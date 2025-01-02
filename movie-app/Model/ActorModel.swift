//
//  ActorModel.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

struct ActorResponse: Codable {
    let page: Int?
    let results: [Actor]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Actor: Codable {
    let id: Int?
    let name: String?
    let profilePath: String?
    var films: [Film]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case films
    }
}

struct Film: Codable {
    let id: Int
    let title: String
}

struct ActorMoviesResponse: Codable {
    let cast: [Film]
}
