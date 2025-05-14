//
//  RepositoryViewModel.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class RepositoryViewModel {
    // MARK: - Drivers
    
    private(set) var states = Driver<CNavigation<States>>.never()
    private(set) var routes = Driver<CNavigation<Routes>>.never()
    
    // MARK: - Constants
    
    let pagination = PaginationSupport(size: 30)
    let viewTitle: String
    private var isLoading = false
    let emptyResponseMessage = "Não há pull requests para esse repositório"
    
    // MARK: - Variables
    
    var pullsList: [RepositoryPullModel] = []
    var openedPullText = ""
    var closedPullText = ""
    
    // MARK: - Observable State
    
    var loadData = PublishSubject<Bool>()
    var showData: Observable<Void> = .empty()
    var showError: Observable<Void> = .empty()
    
    // MARK: Actions
    
    let didTapBack = PublishSubject<Void>()
    
    init(service: RepositoryServiceProtocol = RepositoryService(), owner: String, repo: String) {
        viewTitle = repo
        states = initStates(service: service, owner: owner, repo: repo)
        routes = initRoutes()
    }
}

extension RepositoryViewModel {
    func set(event: Event) {
        switch event {
        case .loadRepositories, .tapRetry:
            guard !isLoading else { return }
            isLoading = true
            loadData.onNext(false)
        case let .reloadRepositories(reload):
            guard !isLoading else { return }
            isLoading = true
            loadData.onNext(reload)
        }
    }
}

// MARK: - Public Methods

extension RepositoryViewModel {
    
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
    
    func setupPullsList(pullsListResponse: [RepositoryPullModel]) {
        let existingRepositories = Set(self.pullsList.map({ $0.id }))
        let newItems = pullsListResponse.filter {
            !existingRepositories.contains($0.id)
        }
        self.pullsList.append(contentsOf: newItems)
    }
    
    func setupPullTexts(pulls: [RepositoryPullModel]) {
        var openedNumber: Int = 0
        var closedNumber: Int = 0
        for pulls in pulls {
            if pulls.state == .open {
                openedNumber += 1
            } else {
                closedNumber += 1
            }
        }
        openedPullText = "\(openedNumber) opened"
        closedPullText = "\(closedNumber) closed"
    }
    
    func setupDates(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

// MARK: - Internal Methods

private extension RepositoryViewModel {
    
    func initStates(service: RepositoryServiceProtocol, owner: String, repo: String) -> Driver<CNavigation<States>> {
        
        let loadRepositories = loadData.flatMap { [weak self] reload -> Observable<CNavigation<States>> in
            guard let self = self else {
                return .just(.init(type: .error))
            }
            
            return Observable<CNavigation<States>>.create { observer in
                observer.onNext(.init(type: .loading))
                self.getRepositoryPullData(service: service, owner: owner, repo: repo, completion: { result in
                    self.isLoading = false
                    if let result = result {
                        self.setupPullsList(pullsListResponse: result)
                        self.setupPullTexts(pulls: result)
                        if result.isEmpty {
                            observer.onNext(.init(type: .responseEmpty))
                        } else {
                            observer.onNext(.init(type: .showData))
                        }
                    } else {
                        observer.onNext(.init(type: .error))
                    }
                    observer.onCompleted()
                }, onError: { error in
                    self.isLoading = false
                    observer.onNext(.init(type: .error, info: error.errorDescription))
                    observer.onCompleted()
                })
                return Disposables.create()
            }
        }
        
        return Observable.merge(loadRepositories).asDriver(onErrorRecover: { _ in .never() })
    }
    
    func initRoutes() -> Driver<CNavigation<Routes>> {
        
        let back = didTapBack
            .map {
                CNavigation<Routes>(type: .back)
            }
        
        return Observable.merge(back)
            .asDriver(onErrorRecover: { _ in .empty() })
    }
}

// MARK: - Service Callers

extension RepositoryViewModel {
    func getRepositoryPullData(service: RepositoryServiceProtocol, owner: String, repo: String, completion: @escaping ([RepositoryPullModel]?) -> Void, onError: @escaping (AFError) -> Void) {
        service.getPullList(user: owner, repository: repo, completion: { result in
            if result != nil {
                completion(result)
            }
        }, onError: { error in
            onError(error)
        })
    }
}

extension RepositoryViewModel {
    enum Event {
        case loadRepositories
        case reloadRepositories(Bool)
        case tapRetry
    }
    
    enum States {
        case error
        case loading
        case showData
        case responseEmpty
    }
    
    enum Routes {
        case back
    }
}

