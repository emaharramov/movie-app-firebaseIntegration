//
//  ActorsFilmViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

import UIKit

class ActorsFilmViewController: UIViewController {
    @IBOutlet weak var filmsTableView: UITableView!
    
    var actor: Actor?
    private let viewModel = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureUI()
    }
    
    fileprivate func configureUI() {
        
        filmsTableView.delegate = self
        filmsTableView.dataSource = self
        
        if let actor = actor {
            self.title = actor.name
            viewModel.getActorMovies(actorId: actor.id ?? 0)
        }
    }
    
    fileprivate func configureViewModel() {
        showLoading()
        viewModel.loadMovie()
        
        viewModel.success = { [weak self] in
            self?.hideLoading()
            self?.filmsTableView.reloadData()
        }
        
        viewModel.error = { [weak self] error in
            self?.showAlert(title: "Error", message: "Error Message: \(error)", isError: true)
            self?.hideLoading()
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
