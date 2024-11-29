//
//  FirebaseManager.swift
//  movie-app
//
//  Created by Emil Maharramov on 29.11.24.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let firestore = Firestore.firestore()

    func fetchFavorites(completion: @escaping (Result<[(id: String, data: [String: Any])], Error>) -> Void) {
        firestore.collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let favorites = snapshot?.documents.map { (id: $0.documentID, data: $0.data()) } ?? []
                completion(.success(favorites))
            }
        }
    }
    
    func addMovieToFavorites(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let movieId = movie.id else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid movie ID"])))
            return
        }
        
        let favoriteData: [String: Any] = [
            "title": movie.title ?? "No Title",
            "description": movie.overview ?? "No Description",
            "releaseDate": movie.releaseDate ?? "No Date",
            "popularity": movie.popularity ?? 0,
            "voteAverage": movie.voteAverage ?? 0,
            "posterPath": movie.posterPath ?? "No Path",
            "movieId": movieId
        ]
        
        firestore.collection("favorites").addDocument(data: favoriteData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func removeMovieFromFavorites(documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestore.collection("favorites").document(documentId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func isMovieFavorite(movieId: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        firestore.collection("favorites").whereField("movieId", isEqualTo: movieId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = snapshot?.documents.first {
                completion(.success(document.documentID))
            } else {
                completion(.success(nil))
            }
        }
    }
}
