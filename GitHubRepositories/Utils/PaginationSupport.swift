//
//  PaginationSupport.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 12/05/25.
//

import Foundation

public final class PaginationSupport {

    // MARK: Internal variables

    public let size: Int

    public var isLast = false

    public var page = 0

    public var isLoading = false

    public var fixedCells: Int

    // MARK: Private variables

    private var countData: Int = 0

    // MARK: Initializers

    public init(size: Int = 20, fixedCells: Int = 0) {
        self.size = size
        self.fixedCells = fixedCells
    }

    // MARK: Public methods

    public func needCall(reload: Bool = false) -> Bool {
        if reload {
            self.reload()
        }
        return !isLoading && !isLast
    }

    //* Use only one time per requets */
    public func validateIsLast(count: Int) {
        isLast = count < size
        page += 1
        isLoading = false
        countData += count
    }

    public func reload() {
        countData = 0
        page = 0
        isLast = false
    }

    public func startLoading() {
        isLoading = true
        isLast = false
    }

    public func isLoadingCell(row: Int) -> Bool {
        let anotherCells = fixedCells + 1 // Loading
        return isLoading ? row == (countCells() - anotherCells): false
    }

    public func countCells() -> Int {
        let hasLoadingCell = isLoading ? 1 : 0
        return fixedCells + countData + hasLoadingCell
    }
}
