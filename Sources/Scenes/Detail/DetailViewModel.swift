//
//  DetailViewModel.swift
//  OMDBClient
//
//  Created by duc on 14/07/2021.
//

import RxCocoa

final class DetailViewModel: ViewModelType {
    private let useCase: DetailUseCase
    private let movie: Movie

    init(useCase: DetailUseCase, movie: Movie) {
        self.useCase = useCase
        self.movie = movie
    }
    
    func transform(input: Input) -> Output {
        let loadingIndicator = ActivityIndicator()

        let movie = input.loadTrigger
            .flatMapLatest {
                self.useCase.fetchMovieDetail(with: self.movie.id)
                    .trackActivity(loadingIndicator)
                    .asDriver(onErrorJustReturn: self.movie)
            }
            .startWith(self.movie)

        return Output(
            isLoading: loadingIndicator.asDriver(),
            movie: movie
        )
    }
}

extension DetailViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let movie: Driver<Movie>
    }
}
