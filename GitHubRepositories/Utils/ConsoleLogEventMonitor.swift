//
//  ConsoleLogEventMonitor.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 11/05/25.
//

import Foundation
import Alamofire

class ConsoleLogEventMonitor: EventMonitor {
    func requestDidResume(_ request: Request) {
        print("""
            [REQ]: \(request.request?.url?.absoluteString ?? "")
            \(request.cURLDescription())
        """)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("""
            [RESP]: \(request.request?.url?.absoluteString ?? "")
            \(response.debugDescription)
        """)
    }
}
