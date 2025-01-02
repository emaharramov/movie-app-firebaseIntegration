//
//  ActorsFilmViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

import UIKit

class ActorsFilmViewController: UIViewController {
    
    private let viewModel = HomeVM()
    var actor: Actor?
    @IBOutlet weak var filmsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmsTableView.delegate = self
        filmsTableView.dataSource = self
        
        configureViewModel()
        
        if let actor = actor {
            self.title = actor.name
            viewModel.getActorMovies(actorId: actor.id ?? 0)
        }
    }
    
    func configureViewModel() {
        viewModel.loadMovie()
        
        viewModel.success = {
            self.filmsTableView.reloadData()
        }
        
        viewModel.didUpdateMovie = {
            self.filmsTableView.reloadData()
        }
    }
    

}

extension ActorsFilmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularPersonFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath)
        let film = viewModel.popularPersonFilms[indexPath.row]
        cell.textLabel?.text = film.title
        return cell
    }
}
