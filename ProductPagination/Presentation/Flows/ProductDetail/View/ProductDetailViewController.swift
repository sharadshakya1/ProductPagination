//
//  ProductDetailViewController.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 27/12/25.
//

import UIKit

class ProductDetailViewController: UIViewController {

    
    @IBOutlet weak var productsPoster: UIImageView!
    
    @IBOutlet weak var productsTitle: UILabel!
    
    @IBOutlet weak var productsPrice: UILabel!
    
    @IBOutlet weak var productsOverView: UILabel!
    
    
    private var viewmodel : ProductDetailsViewModelProtocol!
    
    
    static func create(viewmodel : ProductDetailsViewModelProtocol) -> ProductDetailViewController {
        guard let vc = UIStoryboard(name: AppConstants.Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: AppConstants.Storyboard.productDetailViewController) as? ProductDetailViewController else { fatalError("not instantiate")}
        vc.viewmodel =  viewmodel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTitle.text = viewmodel.title
        productsPrice.text =  String(format: AppConstants.UIText.priceFormat, viewmodel.price)
        productsOverView.text = viewmodel.overview
        if let imageData = viewmodel.posterImage.value {
            productsPoster.image = UIImage(data: imageData)
        } else {
            productsPoster.image = UIImage(systemName: AppConstants.SFSymbols.photo)
        }
        viewmodel.posterImage.bind { [weak self] data in
            guard let self = self, let data = data else { return }
            self.productsPoster.image = UIImage(data: data)
        } 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Task {
            await viewmodel.updatePosterImage(width: Int(productsPoster.imageSizeAfterAspectFit.scaledSize.width))
        }
    }

}
