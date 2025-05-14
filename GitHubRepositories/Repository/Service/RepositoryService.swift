//
//  RepositoryService.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import Alamofire

protocol RepositoryServiceProtocol {
    func getPullList(user: String, repository: String, completion: @escaping ([RepositoryPullModel]?) -> Void, onError: @escaping (AFError) -> Void)
}

final class RepositoryService: RepositoryServiceProtocol {
    
    let session = Alamofire.Session()
    
    func getPullList(user: String, repository: String, completion: @escaping ([RepositoryPullModel]?) -> Void, onError: @escaping (AFError) -> Void) {
        let urlString = URLs.apiGitHub.appendingFormat("/repos/\(user)/\(repository)/pulls")
        guard let url = URL(string: urlString) else {
            onError(.invalidURL(url: urlString))
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
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
                        let event = try decoder.decode([RepositoryPullModel].self, from: data)
                        completion(event)
                    } catch {
                        onError(.parameterEncoderFailed(reason: .encoderFailed(error: error)))
                    }
                case let .failure(error):
                    print(error)
                    onError(error)
                }
            }
    }
    
    
}
