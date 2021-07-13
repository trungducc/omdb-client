//
//  MoviesViewController.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit
import RxCocoa

class MoviesViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Constants.String.enterFilmName
        return searchController
    }()
    
    private let viewModel: MoviesViewModel
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MoviesViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        bindViewModel()
    }
}

extension MoviesViewController {
    func configureSubviews() {
        title = Constants.String.filmsList
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        
        let spacing = Constants.Movies.spacing
        collectionView.register(of: MovieCell.self)
        collectionView.contentInset = UIEdgeInsets(top: spacing,
                                                   left: spacing,
                                                   bottom: spacing,
                                                   right: spacing)
        collectionView.delegate = self
    }

    func bindViewModel() {
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Movies.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Movies.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfSpacing = Constants.Movies.numberOfCellPerRow * 2 - 1
        let width = (collectionView.bounds.width - Constants.Movies.spacing * CGFloat(numberOfSpacing)) / CGFloat(Constants.Movies.numberOfCellPerRow)
        return CGSize(width: width, height: width / Constants.Movies.cellRatio)
    }
}
