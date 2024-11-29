//
//  MovieCollectionViewCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 15.11.24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var ratingField: UILabel!
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingField.text = "\(String(describing: movie.voteAverage ?? 0.0)) / 10 IMDb"
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        movieImageView.setImage(from: baseURL + (movie.posterPath ?? ""))
    }
}
