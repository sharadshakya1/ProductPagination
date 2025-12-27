//
//  ProductDataService.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 27/12/25.
//

import Foundation


final class ProductDataService : ProductService {
    
    private let urlSession : URLRequestBuilderProtocol
    
    init(urlSession: URLRequestBuilderProtocol) {
        self.urlSession = urlSession
    }
}

extension ProductDataService {
    func fetchProducts(category: String, page: Int, query: String) async throws -> ProductResponse {
        var components = URLComponents(string: AppConstants.API.baseURL)
        
        var queryItems = [
            URLQueryItem(name: AppConstants.API.pageParam, value: "\(page)"),
            URLQueryItem(name: AppConstants.API.limitParam, value: AppConstants.API.defaultLimit)
        ]
        
        if category != AppConstants.Categories.all {
            queryItems.append(URLQueryItem(name: AppConstants.API.categoryParam, value: category))
        }
        
        components?.queryItems = queryItems
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let productsResponse = try await urlSession.fetchURLRequest(
            from: url,
            as: ProductResponse.self
        )
        return productsResponse
    }
}
