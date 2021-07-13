//
//  MovieClient.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import RxSwift

protocol MovieClient {
    func fetchMovies(with query: String, at page: Int) -> Single<[Movie]>
}

class MockMovieClient: MovieClient {
    func fetchMovies(with query: String, at page: Int) -> Single<[Movie]> {
        return Single.create { single in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                single(.success([Movie(x: page)]))
            }
            return Disposables.create {
                print("Cancel")
            }
        }
    }
}
