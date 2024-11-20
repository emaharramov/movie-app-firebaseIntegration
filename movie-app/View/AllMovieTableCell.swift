//
//  AllMovieTableCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 20.11.24.
//

import UIKit

class AllMovieTableCell: UITableViewCell {
    
    @IBOutlet private weak var movieName: UILabel!
    
    func configure(with model: Movie) {
        if let title = model.title {
            movieName.text = title
         } 
    }
    
}
