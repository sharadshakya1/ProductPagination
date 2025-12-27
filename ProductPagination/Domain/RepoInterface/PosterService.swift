//
//  PosterService.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import Foundation


protocol PosterService {
    func getProductsPoster(path: String, width: Int, urlString: String) async throws -> Data
}
