//
//  CategoriesTableViewCell.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var onCategorySelected: ((String, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        categoriesCollectionView.register(UINib(nibName: AppConstants.CellIdentifiers.categoriesCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: AppConstants.CellIdentifiers.categoriesCollectionViewCell)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.backgroundColor = .clear
        
        if let layout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            layout.itemSize = CGSize(width: 100, height: 120)
        }
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func selectFirstCategory() {
        if categories.count > 0 {
            let categoryName = categories[0].title
            onCategorySelected?(categoryName, 0)
        }
    }



    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CellIdentifiers.categoriesCollectionViewCell, for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let isSelected = indexPath == selectedIndexPath
        cell.configure(with: categories[indexPath.row], isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        collectionView.reloadItems(at: [previousIndexPath, indexPath])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let categoryName = categories[indexPath.item].title
        onCategorySelected?(categoryName, indexPath.item)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
