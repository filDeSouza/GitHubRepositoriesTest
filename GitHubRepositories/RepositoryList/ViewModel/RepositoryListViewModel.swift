//
//  RepositoryListViewModel.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class RepositoryListViewModel {
    // MARK: - Drivers
    
    private(set) var states = Driver<CNavigation<States>>.never()
    private(set) var routes = Driver<CNavigation<Routes>>.never()
    
    // MARK: - Constants
    
    let pagination = PaginationSupport(size: 30)
    let viewTitle = "Guithub JavaPop"
    private var isLoading = false
    
    // MARK: - Variables
    
    var page: Int = 1
    var repositoriesList: [RepositoryListModel] = []
    var repositoryData: RepositoryListModel?
    
    // MARK: - Observable State
    
    var loadData = PublishSubject<Bool>()
    var showData: Observable<Void> = .empty()
    var showError: Observable<Void> = .empty()
    
    // MARK: Actions
    
    let didTapOpenRepository = PublishSubject<RepositoryListModel>()
    
    init(service: RepositoryListServiceProtocol = RepositoryListService()) {
        states = initStates(service: service, page: page)
        routes = initRoutes()
    }
}

extension RepositoryListViewModel {
    func set(event: Event) {
        switch event {
        case .loadRepositories, .tapRetry:
            guard !isLoading else { return }
            isLoading = true
            loadData.onNext(false)
        case let .selectRepository(selectedRow):
            didTapOpenRepository.onNext(repositoriesList[selectedRow])
        case let .reloadRepositories(reload):
            guard !isLoading else { return }
            self.page = page + 1
            isLoading = true
            loadData.onNext(reload)
        }
    }
}

// MARK: - Public Methods

extension RepositoryListViewModel {
    
    func setupImageData(imageURL: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    func setupRepositoryList(repositoriesList: [RepositoryListModel]) {
        let existingRepositories = Set(self.repositoriesList.map({ $0.id }))
        let newItems = repositoriesList.filter {
            !existingRepositories.contains($0.id)
        }
        self.repositoriesList.append(contentsOf: newItems)
    }
}

// MARK: - Internal Methods

private extension RepositoryListViewModel {
    
    func initStates(service: RepositoryListServiceProtocol, page: Int) -> Driver<CNavigation<States>> {
        
        let loadRepositories = loadData.flatMap { [weak self] reload -> Observable<CNavigation<States>> in
            guard let self = self else {
                return .just(.init(type: .error))
            }
            
            return Observable<CNavigation<States>>.create { observer in
                observer.onNext(.init(type: .loading))
                self.getRepositoriesData(service: service, page: self.page, completion: { result in
                    self.isLoading = false
                    if let result = result {
                        self.setupRepositoryList(repositoriesList: result.items)
                        observer.onNext(.init(type: .showData))
                    } else {
                        observer.onNext(.init(type: .error))
                    }
                    observer.onCompleted()
                }, onError: { error in
                    self.isLoading = false
                    if reload {
                        observer.onNext(.init(type: .scrollError, info: error.errorDescription))
                    } else {
                        observer.onNext(.init(type: .error, info: error.errorDescription))
                    }
                    observer.onCompleted()
                })
                return Disposables.create()
            }
        }
        
        return Observable.merge(loadRepositories).asDriver(onErrorRecover: { _ in .never() })
    }
    
    func initRoutes() -> Driver<CNavigation<Routes>> {
        
        let openRepository = didTapOpenRepository
            .map { repository in
                return CNavigation<Routes>(type: .openRepository, info: repository)
            }
        
        return Observable.merge(openRepository)
            .asDriver(onErrorRecover: { _ in .empty() })
    }
}

// MARK: - Service Callers

extension RepositoryListViewModel {
    func getRepositoriesData(service: RepositoryListServiceProtocol, page: Int, completion: @escaping (RepositoryListResponse?) -> Void, onError: @escaping (AFError) -> Void) {
        service.getProjectList(page: page, completion: { result in
            if result != nil {
                completion(result)
            }
        }, onError: { error in
            onError(error)
        })
    }
}

extension RepositoryListViewModel {
    enum Event {
        case loadRepositories
        case reloadRepositories(Bool)
        case tapRetry
        case selectRepository(Int)
    }
    
    enum States {
        case error
        case scrollError
        case loading
        case showData
    }
    
    enum Routes {
        case openRepository
    }
}
