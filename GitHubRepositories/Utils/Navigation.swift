//
//  Navigation.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation

public class CNavigation<Destination: Hashable> {
    public var type: Destination
    public var info: Any?

    public init(type: Destination, info: Any? = nil) {
        self.type = type
        self.info = info
    }

    public func getInfo<TypeExpected>() -> TypeExpected? {
        info as? TypeExpected
    }
}
