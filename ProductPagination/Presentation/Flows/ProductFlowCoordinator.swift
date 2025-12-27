//
//  ProductFlowCoordinator.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import UIKit


protocol ProductFlowDependencies {
    func createProductListView(actions : ProductListActions) -> ViewController
    func createProductDetailView(products : Product) -> ProductDetailViewController
}

final class ProductFlowCoordinator {
    
    private weak var navigationController : UINavigationController?
    private let dependencies : ProductFlowDependencies
    
    init(navigationController: UINavigationController, dependencies: ProductFlowDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ProductListActions(productsDetails: productsDetail)
        let vc =  dependencies.createProductListView(actions: actions)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func productsDetail(products : Product) {
        let vc = dependencies.createProductDetailView(products : products)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
