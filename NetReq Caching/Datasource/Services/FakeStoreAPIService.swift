//
//  FakeStoreAPIService.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

import Foundation

protocol FakeStoreAPIServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

class FakeStoreAPIService: FakeStoreAPIServiceProtocol {
    private let baseURL = "https://fakestoreapi.com"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProducts() async throws -> [Product] {
        let url = URL(string: "\(baseURL)/products")!

        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([Product].self, from: data)
    }
}
