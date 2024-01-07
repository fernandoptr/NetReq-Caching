//
//  Product.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let image: String
    let rating: Rating
}


extension Product {
    static var example: Product {
        Product(
            id: 1,
            title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
            price: 109.95,
            image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
            rating: Rating(rate: 3.9, count: 120)
        )
    }
}

