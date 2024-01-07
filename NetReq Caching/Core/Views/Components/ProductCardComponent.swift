//
//  ProductCardComponent.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

import SwiftUI

struct ProductCardComponent: View {
    let product: Product
    let cornerRadius: CGFloat = 16
    let spacing: CGFloat = 12
    
    var body: some View {
        VStack(alignment: .leading) {
            productImage
            productContent
        }
        .background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .foregroundStyle(Color(uiColor: .systemBackground))
                .shadow(radius: 2)
        }
    }
    
    var productImage: some View {
        ZStack {
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: cornerRadius, topTrailing: cornerRadius),
                style: .continuous
            )
            .foregroundStyle(Color(uiColor: .systemGray6))
            AsyncImage(url: URL(string: product.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("Image Error")
                        .font(.title)
                        .foregroundStyle(.gray)
                } else {
                    ProgressView()
                        .font(.largeTitle)
                }
            }
        }
        .frame(height: 200)
    }
    
    var productContent: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(product.title)
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            Text("$\(product.price.description)")
                .font(.title3)
                .bold()
            Text("⭐️ \(product.rating.rate.description) | \(product.rating.count) sold")
                .font(.subheadline)
        }
        .padding(spacing)
    }
}

#Preview {
    ProductCardComponent(product: Product.example)
}
