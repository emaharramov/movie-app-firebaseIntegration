//
//  FavsTableViewCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 18.11.24.
//

import UIKit

protocol FavsTableViewCellDelegate: AnyObject {
    func removeFavorite(for movieId: String)
}

class FavsTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    weak var delegate: FavsTableViewCellDelegate?
    private var movieId: String?

    func configure(with movie: [String: Any], id: String) {
        self.movieId = id
        titleLabel.text = movie["title"] as? String ?? "No Title"
        descriptionLabel.text = movie["description"] as? String ?? "No description available"
        posterImageView.setImage(from: movie["posterPath"] as? String)
    }
    
    @IBAction func removeFavoriteButtonTapped(_ sender: Any) {
        guard let movieId = movieId else { return }
        delegate?.removeFavorite(for: movieId)
    }
}
