//
//  ProductCell.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var productsImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    private var posterService: PosterService!
    private var products: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Container styling
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.masksToBounds = false
        productsImage.layer.cornerRadius = 8
        productsImage.clipsToBounds = true
        productsImage.contentMode = .scaleAspectFill
        productsImage.backgroundColor = UIColor.systemGray6
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .darkGray
        title.numberOfLines = 2
        
        categoryLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        categoryLabel.textColor = UIColor.systemBlue
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }

    func configureData(products: Product, posterRepo: PosterService) {
        self.title.text = products.title
        self.posterService = posterRepo
        self.products = products
        self.overviewLabel.text = products.description
        
        if let price = products.price {
            self.priceLabel.text = String(format: AppConstants.UIText.priceFormat, price)
        }
        
        let categoryText = products.category ?? AppConstants.UIText.uncategorized
        categoryLabel.text = String(format: AppConstants.UIText.categoryFormat, categoryText)
        
        Task {
            await updatePosterImage(width: Int(productsImage.imageSizeAfterAspectFit.scaledSize.width))
        }
    }
    
    @MainActor private func updatePosterImage(width: Int) async {
        productsImage.image = nil
        
        UIView.transition(with: productsImage, duration: 0.2, options: .transitionCrossDissolve) {
            self.productsImage.backgroundColor = UIColor.systemGray5
        }
        
        do {
            let image = try await posterService.getProductsPoster(
                path: "",
                width: width,
                urlString: products.image ?? ""
            )
            
            UIView.transition(with: productsImage, duration: 0.3, options: .transitionCrossDissolve) {
                self.productsImage.image = UIImage(data: image)
            }
        } catch {
            print("⚠️ Image not found")
            productsImage.image = UIImage(systemName: "photo")
            productsImage.tintColor = .systemGray3
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productsImage.image = nil
        productsImage.backgroundColor = UIColor.systemGray6
    }
}




extension UIImageView {

    var imageSizeAfterAspectFit: CGSize {
        var newWidth: CGFloat
        var newHeight: CGFloat

        guard let image = image else { return frame.size }

        if image.size.height >= image.size.width {
            newHeight = frame.size.height
            newWidth = ((image.size.width / (image.size.height)) * newHeight)

            if CGFloat(newWidth) > (frame.size.width) {
                let diff = (frame.size.width) - newWidth
                newHeight = newHeight + CGFloat(diff) / newHeight * newHeight
                newWidth = frame.size.width
            }
        } else {
            newWidth = frame.size.width
            newHeight = (image.size.height / image.size.width) * newWidth

            if newHeight > frame.size.height {
                let diff = Float((frame.size.height) - newHeight)
                newWidth = newWidth + CGFloat(diff) / newWidth * newWidth
                newHeight = frame.size.height
            }
        }
        return .init(width: newWidth, height: newHeight)
    }
}

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
