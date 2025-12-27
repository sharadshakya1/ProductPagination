//
//  AppFlowCoordinator.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import UIKit


final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: ProductDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: ProductDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let productsDIContainer = appDIContainer.createProductsFlowCoordinator(navigationController: navigationController)
        productsDIContainer.start()
    }
    
}
