//
//  ProductGridView.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

import SwiftUI

struct ProductGridView: View {
    @StateObject private var viewModel = ProductGridViewModel()
    let spacing: CGFloat = 16
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .success:
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: spacing), count: 2), spacing: spacing) {
                            ForEach(viewModel.products) { product in
                                ProductCardComponent(product: product)
                            }
                        }
                        .padding()
                    }
                case .error:
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.warninglight")
                            .font(.system(size: 64))
                        Text("Oops! Something went wrong. Try again later")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .navigationTitle("Products")
            .task {
                await viewModel.fetchData()
            }
        }
    }
}

#Preview {
    ProductGridView()
}
