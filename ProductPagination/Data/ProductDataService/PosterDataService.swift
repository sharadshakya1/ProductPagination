//
//  PosterDataService.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import Foundation


final class PosterDataService : PosterService {
    
    private let urlSession : URLRequestBuilderProtocol
    
    init(urlSession: URLRequestBuilderProtocol) {
        self.urlSession = urlSession
    }
    
}

extension PosterDataService {
    
    func getProductsPoster(path: String, width: Int, urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {throw NetworkError.invalidURL}
        let imageResponse = try await urlSession.fetchURLRequest(from: url, as: Data.self)
        print(url , imageResponse)
        return imageResponse
    }
}
