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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: FavsTableViewCellDelegate?
    private var movieId: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with movie: [String: Any], id: String) {
        self.movieId = id
        titleLabel.text = movie["title"] as? String ?? "No Title"
        descriptionLabel.text = movie["description"] as? String ?? "No description available"
        
        if let posterPath = movie["posterPath"] as? String,
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            posterImageView.kf.setImage(with: imageUrl)
        } else {
            posterImageView.image = UIImage(named: "default_poster")
        }
    }
    
    @IBAction func removeFavoriteButtonTapped(_ sender: Any) {
        guard let movieId = movieId else {
            return
        }
        delegate?.removeFavorite(for: movieId)
    }
}
