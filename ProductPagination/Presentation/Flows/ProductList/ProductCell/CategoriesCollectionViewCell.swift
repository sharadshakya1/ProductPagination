//
//  CategoriesCollectionViewCell.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 27/12/25.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         setupUI()
     }
     
     private func setupUI() {
         containerView.layer.cornerRadius = 12
         containerView.layer.masksToBounds = false
         containerView.layer.shadowColor = UIColor.black.cgColor
         containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
         containerView.layer.shadowRadius = 4
         containerView.layer.shadowOpacity = 0
         imageView.layer.cornerRadius = 8
         imageView.clipsToBounds = true
         imageView.contentMode = .scaleAspectFill
         title.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
         title.textAlignment = .center
     }
     
     func configure(with category: Category, isSelected: Bool) {
         title.text = category.title
         imageView.image = UIImage(named: category.title)
         
         updateSelectionState(isSelected: isSelected)
     }
     
     private func updateSelectionState(isSelected: Bool) {
         UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
             if isSelected {
                 self.containerView.backgroundColor = .white
                 self.containerView.layer.borderWidth = 5
                 self.containerView.layer.borderColor = UIColor.systemBlue.cgColor
                 self.containerView.layer.shadowOpacity = 0.3
                 self.containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                 self.title.textColor = UIColor.systemBlue
                 self.imageView.alpha = 1.0
             } else {
                 self.containerView.backgroundColor = .white
                 self.containerView.layer.borderWidth = 1
                 self.containerView.layer.borderColor = UIColor.systemGray4.cgColor
                 self.containerView.layer.shadowOpacity = 0.1
                 self.containerView.transform = .identity
                 self.title.textColor = UIColor.darkGray
                 self.imageView.alpha = 0.7
             }
         }
     }
     
     override func prepareForReuse() {
         super.prepareForReuse()
         imageView.image = nil
         containerView.transform = .identity
     }
 }
