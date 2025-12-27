//
//  ProductService.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import Foundation



protocol ProductService {
    func fetchProducts(category: String , page : Int , query : String) async throws -> ProductResponse 
}













