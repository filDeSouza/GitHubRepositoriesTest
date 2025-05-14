//
//  RepositoryListService.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation
import Alamofire

enum returnCodeAPI {
    case success
}

protocol RepositoryListServiceProtocol {
    func getProjectList(page: Int, completion: @escaping (RepositoryListResponse?) -> Void, onError: @escaping (AFError) -> Void)
}

final class RepositoryListService: RepositoryListServiceProtocol {
    
    let session = Alamofire.Session()
    let keys = Keys()
    
    func getProjectList(page: Int, completion: @escaping (RepositoryListResponse?) -> Void, onError: @escaping (AFError) -> Void) {
        let urlString = URLs.apiGitHub.appendingFormat("/search/repositories?q=language:Java&sort=stars&page=%d&per_page=30", page)
        guard let url = URL(string: urlString) else {
            onError(.invalidURL(url: urlString))
            return
        }
        
        var request = URLRequest(url: url)
        // A Api do git possui uma restrição do número de requisições realizadas, por esse motivo essa chave esta incluída. Para o push, essa chave esta sendo comentada
//        request.setValue(keys.gitToken, forHTTPHeaderField: "Authorization")
                        
        session.request(request)
            .validate(statusCode: 200...299)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    do{
                        let event = try JSONDecoder().decode(RepositoryListResponse.self, from: data)
                        completion(event)
                    } catch {
                        print(error)
                        onError(.parameterEncoderFailed(reason: .encoderFailed(error: error)))
                    }
                case let .failure(error):
                    print(error)
                    onError(error)
                }
            }
    }
}
