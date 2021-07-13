//
//  MoviesUseCase.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import RxSwift

protocol MoviesUseCase {
    func fetchMovies(with query: String, at page: Int) -> Observable<[Movie]>
}

final class DefaultMoviesUseCase {
    private let movieService: MovieClient
    
    init(movieService: MovieClient) {
        self.movieService = movieService
    }
}

extension DefaultMoviesUseCase: MoviesUseCase {
    func fetchMovies(with query: String, at page: Int) -> Observable<[Movie]> {
        return movieService.fetchMovies(with: query, at: page).asObservable()
    }
}
