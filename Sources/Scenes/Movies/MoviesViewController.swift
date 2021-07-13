//
//  MoviesViewController.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

class MoviesViewController: UIViewController {
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
        view.backgroundColor = .red
    }

    func bindViewModel() {
    }
}
