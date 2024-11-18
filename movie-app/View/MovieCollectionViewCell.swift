//
//  MovieCollectionViewCell.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var ratingField: UILabel!
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingField.text = "\(String(describing: movie.voteAverage!)) / 10 IMDb"
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let fullPath = baseURL + posterPath
            let url = URL(string: fullPath)
            movieImageView.kf.setImage(with: url)
        } else {
            movieImageView.image = UIImage(named: "default_poster")
        }
    }
}
