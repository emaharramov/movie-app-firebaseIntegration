//
//  ActSimViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

import UIKit

class ActSimViewController: UIViewController {
    
    private let viewModel = HomeVM()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureViewModel()
    }
    
    func configureViewModel() {
        viewModel.loadMovie()
        
        viewModel.success = {
            self.collectionView.reloadData()
        }
        
        viewModel.didUpdateMovie = {
            self.collectionView.reloadData()
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ActSimCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActSimCollectionViewCell")
    }

   
}

extension ActSimViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.popularPerson.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActSimCollectionViewCell", for: indexPath) as! ActSimCollectionViewCell
        let actor = viewModel.popularPerson[indexPath.row]
        cell.configure(with: actor)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedActor = viewModel.popularPerson[indexPath.row]
            
            // ActorsFilmViewController'a geçiş
            if let actorsFilmVC = storyboard?.instantiateViewController(withIdentifier: "ActorsFilmViewController") as? ActorsFilmViewController {
                actorsFilmVC.actor = selectedActor 
                navigationController?.pushViewController(actorsFilmVC, animated: true)
            }
        }
}

