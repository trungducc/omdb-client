//
//  MoviesViewModel.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import RxCocoa

final class MoviesViewModel: ViewModelType {
    private let useCase: MoviesUseCase
    private let navigator: MoviesNavigator
    
    private var nextPage = Constants.Movies.firstPageIndex
    private var snapshot = BehaviorRelay(value: NSDiffableDataSourceSnapshot<Section, AnyHashable>())
    private var emptyViewState = BehaviorRelay(value: EmptyView.State.welcome)
    
    init(useCase: MoviesUseCase, navigator: MoviesNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let queryChangedTrigger = input.queryChangedTrigger
            .distinctUntilChanged()
            .do(onNext: { _ in
                self.nextPage = Constants.Movies.firstPageIndex
                self.snapshot.accept(NSDiffableDataSourceSnapshot<Section, AnyHashable>())
            })
            .debounce(.milliseconds(Constants.Movies.searchDebounceTime))
        
        let reload = queryChangedTrigger
            .filter { !$0.isEmpty }
            .do(onNext: { _ in
                self.updateSnapshot(with: [], shouldAddLoadMoreSection: true)
            })
            .map { _ in }
        
        let fetchMovies = { query in
            self.useCase.fetchMovies(with: query, at: self.nextPage)
                .withLatestFrom(input.queryChangedTrigger) { (movies: $0, currentQuery: $1) }
                .filter { query == $0.currentQuery }
                .map { $0.movies }
                .do(onNext: { movies in
                    if movies.isEmpty, self.nextPage == Constants.Movies.firstPageIndex {
                        self.emptyViewState.accept(EmptyView.State.empty)
                    }
                    
                    self.nextPage += 1
                    self.updateSnapshot(with: movies, shouldAddLoadMoreSection: !movies.isEmpty)
                }, onError: { _ in
                    self.updateSnapshot(with: [], shouldAddLoadMoreSection: false)
                    self.emptyViewState.accept(EmptyView.State.error)
                })
                .asDriverOnErrorJustComplete()
        }
        let loadMore = input.loadMoreTrigger
            .withLatestFrom(input.queryChangedTrigger) { $1 }
            .flatMapLatest { query in
                fetchMovies(query)
            }.map { _ in }
        
        let welcome = queryChangedTrigger
            .filter { $0.isEmpty }
            .do(onNext: { _ in
                self.emptyViewState.accept(EmptyView.State.welcome)
            })
        let hidden = queryChangedTrigger
            .filter { !$0.isEmpty }
            .do(onNext: { _ in
                self.emptyViewState.accept(EmptyView.State.hidden)
            })
        let emptyViewState = self.emptyViewState
            .withLatestFrom(Driver.merge(welcome, hidden)) { state, _ in state }
            .asDriverOnErrorJustComplete()
        
        let toDetail = input.toDetailTrigger
            .do(onNext: navigator.toDetail)
            .map { _ in }

        return Output(
            emptyViewState: emptyViewState,
            snapshot: snapshot.asDriver(),
            reload: reload,
            loadMore: loadMore,
            toDetail: toDetail
        )
    }
    
    private func updateSnapshot(with movies: [Movie], shouldAddLoadMoreSection: Bool) {
        assert(Thread.isMainThread)

        var newSnapshot = self.snapshot.value
        
        let hasMoviesSection = newSnapshot.indexOfSection(.movies) != nil
        if !hasMoviesSection {
            newSnapshot.appendSections([.movies])
        }
        newSnapshot.appendItems(movies, toSection: .movies)
        
        let hasLoadMoreSection = newSnapshot.indexOfSection(.loadMore) != nil
        if hasLoadMoreSection {
            if !shouldAddLoadMoreSection {
                newSnapshot.deleteSections([.loadMore])
            } else {
                newSnapshot.reloadSections([.loadMore])
            }
        } else if shouldAddLoadMoreSection {
            newSnapshot.appendSections([.loadMore])
            newSnapshot.appendItems([""])
        }

        self.snapshot.accept(newSnapshot)
    }
}

extension MoviesViewModel {
    struct Input {
        let queryChangedTrigger: Driver<String>
        let loadMoreTrigger: Driver<Void>
        let toDetailTrigger: Driver<Movie>
    }
    
    struct Output {
        let emptyViewState: Driver<EmptyView.State>
        let snapshot: Driver<NSDiffableDataSourceSnapshot<Section, AnyHashable>>
        let reload: Driver<Void>
        let loadMore: Driver<Void>
        let toDetail: Driver<Void>
    }
}
