//
//  ActorAndSimilarViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

import UIKit

class ActorAndSimilarViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureViewModel()
    }
    
    fileprivate func configureViewModel() {

        showLoading()
        
        viewModel.loadMovie()
        
        viewModel.success = { [weak self] in
            self?.hideLoading()
            self?.collectionView.reloadData()
        }
        
        viewModel.error = { [weak self] error in
            self?.showAlert(title: "Error", message: "Error Message: \(error)", isError: true)
            self?.hideLoading()
        }
    }

    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TopImageBottomLabelCell", bundle: nil), forCellWithReuseIdentifier: "TopImageBottomLabelCell")
    }
}

extension ActorAndSimilarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.popularPerson.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageBottomLabelCell", for: indexPath) as! TopImageBottomLabelCell
        let actor = viewModel.popularPerson[indexPath.row]
        cell.configure(data: actor)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedActor = viewModel.popularPerson[indexPath.row]
            
            if let actorsFilmVC = storyboard?.instantiateViewController(withIdentifier: "ActorsFilmViewController") as? ActorsFilmViewController {
                actorsFilmVC.actor = selectedActor 
                navigationController?.pushViewController(actorsFilmVC, animated: true)
            }
        }
}

