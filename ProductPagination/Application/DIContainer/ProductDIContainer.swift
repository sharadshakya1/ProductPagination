//
//  ProductDIContainer.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import UIKit

final class ProductDIContainer {
    
   
    // MARK: - URLSessionManager
    
    func createURLSessionManager() -> URLRequestBuilderProtocol {
        return URLRequestBuilder()
    }
    
    // MARK: - Poster Repository
    func createPosterService() -> PosterService {
        return PosterDataService(urlSession: createURLSessionManager())
    }
    
    // MARK: - Dependencies for Product List
    func createProductService() -> ProductService {
        return ProductDataService(urlSession: createURLSessionManager())
    }
    
    func createProductViewModel(actions : ProductListActions) -> ProductViewModelProtocol {
        return ProductListViewModel(productsService: createProductService(), actions: actions)
    }
    
    func createProductListView(actions : ProductListActions) -> ViewController {
        return ViewController.create(with: createProductViewModel(actions: actions), posterService: createPosterService())
    }
    
    // MARK: - Dependencies for Product Detail
    func createProducDetailsViewModel(products : Product) -> ProductDetailsViewModelProtocol {
        return ProductDetailViewModel(products: products, posterService: createPosterService())
    }
    
    
    func createProductDetailView(products : Product) -> ProductDetailViewController {
        return ProductDetailViewController.create(viewmodel: createProducDetailsViewModel(products: products))
    }
    
    //MARK: - Flow Coordinator
    
    func createProductsFlowCoordinator(navigationController: UINavigationController) -> ProductFlowCoordinator {
        ProductFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
}

extension  ProductDIContainer : ProductFlowDependencies { }




















