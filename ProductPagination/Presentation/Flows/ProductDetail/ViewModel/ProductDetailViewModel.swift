//
//  ProductDetailViewModel.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 27/12/25.
//

import Foundation


protocol ProductDetailsViewModelProtocol {
    var title: String { get }
    var posterImage: Observable<Data?> { get }
    var overview: String { get }
    var price : Double { get }
    func updatePosterImage(width: Int) async
}

final class ProductDetailViewModel : ProductDetailsViewModelProtocol {
    
    
    var title: String
    var posterImage: Observable<Data?>  = Observable(nil)
    var overview: String
    private let posterImagePath: String?
    var price : Double
    
    private var posterService : PosterService
    
    init(products : Product, posterService: PosterService) {
        self.title = products.title ?? ""
        self.posterImagePath = products.image ?? ""
        self.overview = products.description ?? ""
        self.posterService = posterService
        self.price = products.price ?? 0
    }
    
}

extension ProductDetailViewModel {
    
    @MainActor func updatePosterImage(width: Int) async {
        guard let posterImagePath = posterImagePath else { return }
        
        do {
            let image = try await posterService.getProductsPoster(path: posterImagePath, width: width, urlString: posterImagePath)
            posterImage.value = image
        } catch {
            print("image not Found")
        }
    }
}
