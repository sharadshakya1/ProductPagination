//
//  Entity.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import Foundation

struct ProductResponse: Codable {
    var data: [Product]
    var pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
}

// MARK: - Pagination
struct Pagination: Codable, Equatable {
    var page: Int
    var limit: Int
    var total: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case limit
        case total
    }
}

// MARK: - Product
struct Product: Codable, Identifiable, Equatable {
    var id: Int
    var title: String?
    var price: Double?
    var description: String?
    var category: String?
    var brand: String?
    var stock: Int?
    var image: String?
    var specs: Specs?
    var rating: Rating?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case description
        case category
        case brand
        case stock
        case image
        case specs
        case rating
    }
}

// MARK: - Specs
struct Specs: Codable, Equatable {
    var color: String?
    var weight: String?
    var storage: String?
    var battery: String?
    var waterproof: Bool?
    
    enum CodingKeys: String, CodingKey {
        case color
        case weight
        case storage
        case battery
        case waterproof
    }
}

// MARK: - Rating
struct Rating: Codable, Equatable {
    var rate: Double?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case rate
        case count
    }
}


struct Category {
    var title: String
}

var categories: [Category] = [
    Category(title: AppConstants.Categories.all),
    Category(title: AppConstants.Categories.accessories),
    Category(title: AppConstants.Categories.furniture),
    Category(title: AppConstants.Categories.electronics),
    Category(title: AppConstants.Categories.sports),
    Category(title: AppConstants.Categories.appliances),
    Category(title: AppConstants.Categories.footwear),
    Category(title: AppConstants.Categories.clothing)
]


