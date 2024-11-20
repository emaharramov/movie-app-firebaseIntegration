//
//  AllMovieTableCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 20.11.24.
//

import UIKit

class AllMovieTableCell: UITableViewCell {
    
    @IBOutlet private weak var imageField: UIImageView!
    @IBOutlet private weak var movieName: UILabel!
    @IBOutlet private weak var descriptionField: UILabel!
    
    func configure(with model: Movie) {
        movieName.text = model.title
        descriptionField.text = model.overview
        if let posterPath = model.posterPath, !posterPath.isEmpty {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let fullPath = baseURL + posterPath
            let url = URL(string: fullPath)
            imageField.kf.setImage(with: url)
        } else {
            imageField.image = UIImage(named: "default_poster")
        }
    }

}
