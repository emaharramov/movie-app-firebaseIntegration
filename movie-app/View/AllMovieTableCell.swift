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
        imageField.setImage(from: model.posterPath)
    }
}
