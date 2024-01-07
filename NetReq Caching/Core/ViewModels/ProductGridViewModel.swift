//
//  ProductGridViewModel.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

import Foundation
import Combine

class ProductGridViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var state: AppState = .loading
    private let repository: FakeStoreAPIRepositoryProtocol

    init(repository: FakeStoreAPIRepositoryProtocol = FakeStoreAPIRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func fetchData() async {
        do {
            state = .loading
            products = try await repository.fetchProducts()
            state = .success
        } catch {
            state = .error(error)
        }
    }
}
