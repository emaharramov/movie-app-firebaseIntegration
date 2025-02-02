//
//  MovieDetailCollectionViewCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 01.01.25.
//

import UIKit
import Kingfisher

class MovieDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview ?? "No description available."
        releaseDateLabel.text = "Release Date: \(movie.releaseDate ?? "Unknown")"
        popularityLabel.text = "Popularity: \(movie.popularity?.description ?? "Not available")"
        voteCountLabel.text = "Vote: \(movie.voteAverage?.description ?? "0") / 10"
        
        if let posterPath = movie.posterPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            imageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
