//
//  MoviesNavigator.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

protocol MoviesNavigator {
    func toDetail(of movie: Movie)
}

final class DefaultMoviesNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension DefaultMoviesNavigator: MoviesNavigator {
    func toDetail(of movie: Movie) {
        print("COMMING SOON")
    }
}
