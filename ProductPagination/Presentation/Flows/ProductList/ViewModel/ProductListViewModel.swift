//
//  ProductListViewModel.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 27/12/25.
//

import Foundation



struct ProductListActions {
    let productsDetails: (Product) -> Void
}

protocol ProductViewModelProtocol {
    var items: Observable<[Product]> { get set }
    var isLoader: Observable<Bool> { get }
    var errorState: Observable<NetworkError?> { get }
    var showNoDataAlert: Observable<Bool> { get }
    
    func initialProducts(category: String, query: String, page: Int) async
    func retryLastRequest() async
    func didSelectRowAt(index: Int)
    func didLoadNextPage() async
}

final class ProductListViewModel: ProductViewModelProtocol {
    
    var items: Observable<[Product]> = Observable([])
    var isLoader: Observable<Bool> = Observable(false)
    var errorState: Observable<NetworkError?> = Observable(nil)
    var showNoDataAlert: Observable<Bool> = Observable(false)
    
    private var currentPage = 0
    private var totalItems = 0
    private var itemsPerPage = 10
    private var fetchQuery = ""
    private var currentCategory = ""
    private var isFetching = false
    
    private var hasMorePages: Bool {
        let totalPages = (totalItems + itemsPerPage - 1) / itemsPerPage
        return currentPage < totalPages
    }
    
    private let productsService: ProductService
    private let actions: ProductListActions
    
    init(productsService: ProductService, actions: ProductListActions) {
        self.productsService = productsService
        self.actions = actions
    }
    
    @MainActor
    private func fetchProducts(category: String, query: String, page: Int, isInitial: Bool = false) async {
        guard !isFetching else { return }
        guard isInitial || hasMorePages else {
            isLoader.value = false
            return
        }
        
        isFetching = true
        isLoader.value = true
        errorState.value = nil
        
        do {
            let response = try await productsService.fetchProducts(category: category, page: page, query: query)
            
            if isInitial {
                items.value = []
            }
            
            totalItems = response.pagination.total
            itemsPerPage = response.pagination.limit
            currentPage = response.pagination.page
            fetchQuery = query
            currentCategory = category
            
            if !isInitial && response.data.isEmpty {
                showNoDataAlert.value = true
            } else {
                items.value.append(contentsOf: response.data)
            }
            
            if isInitial && response.data.isEmpty {
                showNoDataAlert.value = true
            }
            
        } catch let error as NetworkError {
            errorState.value = error
            if isInitial {
                items.value = []
            }
        } catch {
            errorState.value = .unknown(error)
            if isInitial {
                items.value = []
            }
        }
        
        isLoader.value = false
        isFetching = false
    }
    
    func initialProducts(category: String, query: String, page: Int) async {
        await fetchProducts(category: category, query: query, page: 0, isInitial: true)
    }
    
    func retryLastRequest() async {
        guard !currentCategory.isEmpty else { return }
        await fetchProducts(category: currentCategory, query: fetchQuery, page: 0, isInitial: true)
    }
    
    func didSelectRowAt(index: Int) {
        guard index < items.value.count else { return }
        actions.productsDetails(items.value[index])
    }
    
    func didLoadNextPage() async {
        guard hasMorePages && !isFetching else { return }
        await fetchProducts(category: currentCategory, query: fetchQuery, page: currentPage + 1)
    }
}
