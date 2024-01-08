//
//  FakeStoreAPIRepository.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

import Foundation
import CoreData

protocol FakeStoreAPIRepositoryProtocol {
    func fetchProducts() async throws -> [Product]
}

class FakeStoreAPIRepository: FakeStoreAPIRepositoryProtocol {
    private let service: FakeStoreAPIServiceProtocol
    private let stack: CoreDataStack

    init(
        service: FakeStoreAPIServiceProtocol = FakeStoreAPIService(),
        stack: CoreDataStack = CoreDataStack.shared
    ) {
        self.service = service
        self.stack = stack
    }

    func fetchProducts() async throws -> [Product] {
        do {
            let cachedProducts = try loadCachedProducts()
            if !cachedProducts.isEmpty {
                return cachedProducts.map { mapEntityToModel($0) }
            } else {
                let products = try await service.fetchProducts()
                await saveToCoreData(products)
                return products
            }
        } catch {
            print("Error fetching products: \(error.localizedDescription)")
            throw error
        }
    }

    private func loadCachedProducts() throws -> [ProductEntity] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        return try stack.viewContext.fetch(request)
    }

    private func saveToCoreData(_ products: [Product]) async {
        let context = stack.viewContext
        await context.perform {
            for product in products {
                let productEntity = ProductEntity(context: context)
                self.mapModelToEntity(product, productEntity)
            }
            do {
                try context.save()
            } catch {
                print("Error saving to Core Data: \(error.localizedDescription)")
            }
        }
    }

    private func mapModelToEntity(_ product: Product, _ productEntity: ProductEntity) {
        productEntity.id = Int16(product.id)
        productEntity.title = product.title
        productEntity.price = product.price
        productEntity.image = product.image

        let ratingEntity = RatingEntity(context: stack.viewContext)
        ratingEntity.rate = product.rating.rate
        ratingEntity.count = Int16(product.rating.count)

        productEntity.rating = ratingEntity
    }

    private func mapEntityToModel(_ productEntity: ProductEntity) -> Product {
        return Product(
            id: Int(productEntity.id),
            title: productEntity.title ?? "",
            price: productEntity.price,
            image: productEntity.image ?? "",
            rating: Product.Rating(rate: productEntity.rating?.rate ?? 0, count: Int(productEntity.rating?.count ?? 0))
        )
    }
}
