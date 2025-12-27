//
//  Constants.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 27/12/25.
//

import Foundation

enum AppConstants {
    
    // MARK: - Cell Identifiers
    enum CellIdentifiers {
        static let productCell = "ProductCell"
        static let categoriesTableViewCell = "CategoriesTableViewCell"
        static let categoriesCollectionViewCell = "CategoriesCollectionViewCell"
    }
    
    // MARK: - Storyboard
    enum Storyboard {
        static let main = "Main"
        static let viewController = "ViewController"
        static let productDetailViewController = "ProductDetailViewController"
    }
    
    // MARK: - API
    enum API {
        static let baseURL = "https://fakeapi.net/products"
        static let pageParam = "page"
        static let limitParam = "limit"
        static let categoryParam = "category"
        static let defaultLimit = "10"
    }
    
    // MARK: - Categories
    enum Categories {
        static let all = "All"
        static let accessories = "accessories"
        static let furniture = "furniture"
        static let electronics = "electronics"
        static let sports = "sports"
        static let appliances = "appliances"
        static let footwear = "footwear"
        static let clothing = "clothing"
        
    }
    
    // MARK: - SF Symbols
    enum SFSymbols {
        static let photo = "photo"
        static let wifiSlash = "wifi.slash"
        static let clockArrowCirclepath = "clock.arrow.circlepath"
        static let exclamationmarkTriangle = "exclamationmark.triangle"
    }
    
    
    // MARK: - Alert Titles
    enum AlertTitles {
        static let noInternet = "No Internet Connection"
        static let invalidURL = "Invalid URL"
        static let serverError = "Server Error"
        static let dataError = "Data Error"
        static let requestTimeout = "Request Timeout"
        static let somethingWrong = "Something Went Wrong"
        static let noData = "No Data"
    }
    
    // MARK: - Alert Messages
    enum AlertMessages {
        static let checkConnection = "Please check your internet connection and try again."
        static let resourceNotFound = "The requested resource could not be found."
        static let serverUnavailable = "Unable to connect to the server. Please try again later."
        static let processDataError = "Unable to process the data. Please try again."
        static let requestTooLong = "The request took too long. Please check your connection."
        static let noProductsAvailable = "No products available for this category."
    }
    
    // MARK: - Button Titles
    enum ButtonTitles {
        static let tryAgain = "Try Again"
        static let cancel = "Cancel"
        static let ok = "OK"
    }
    
    // MARK: - UI Text
    enum UIText {
        static let priceFormat = "₹%.2f"
        static let categoryFormat = "📦 %@"
        static let uncategorized = "Uncategorized"
    }
    
    // MARK: - Notification Names
    enum NotificationNames {
        static let networkStatusChanged = "networkStatusChanged"
    }
    
    // MARK: - Queue Names
    enum QueueNames {
        static let networkMonitor = "NetworkMonitor"
    }
    
}
