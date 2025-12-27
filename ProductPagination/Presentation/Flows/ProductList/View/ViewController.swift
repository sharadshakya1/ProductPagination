//
//  ViewController.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var productssTableView: UITableView!
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    private var viewModel: ProductViewModelProtocol!
    private var posterService: PosterService!
    private var isLoadingMore = false
    private var currentCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        bind()
        setupErrorHandling()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        productssTableView.backgroundColor = .clear
        productssTableView.separatorStyle = .none
        productssTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    private func bind() {
        viewModel.items.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.productssTableView.reloadData()
                self?.isLoadingMore = false
            }
        }
        
        viewModel.isLoader.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityLoader.startAnimating() : self?.activityLoader.stopAnimating()
                self?.activityLoader.isHidden = !isLoading
                self?.isLoadingMore = false
            }
        }
        
        viewModel.showNoDataAlert.bind { [weak self] shouldShow in
            guard let self = self, shouldShow else { return }
            DispatchQueue.main.async {
                self.showNoDataAlert()
                self.viewModel.showNoDataAlert.value = false
            }
        }
    }
    
    private func loadProductsForCategory(_ category: String) {
        currentCategory = category
        Task {
            await viewModel.initialProducts(category: category, query: "", page: 0)
        }
    }
    
    private func registerCell() {
        productssTableView.register(UINib(nibName: AppConstants.CellIdentifiers.productCell, bundle: nil), forCellReuseIdentifier: AppConstants.CellIdentifiers.productCell)
        productssTableView.register(UINib(nibName: AppConstants.CellIdentifiers.categoriesTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.CellIdentifiers.categoriesTableViewCell)
        productssTableView.delegate = self
        productssTableView.dataSource = self
    }
    
    private func setupErrorHandling() {
        viewModel.errorState.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(error: error) {
                    Task { await self.viewModel.retryLastRequest() }
                }
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .networkStatusChanged,
            object: nil
        )
    }
    
    @objc private func networkStatusChanged(_ notification: Notification) {
        guard let isConnected = notification.userInfo?["isConnected"] as? Bool,
              let wasConnected = notification.userInfo?["wasConnected"] as? Bool,
              !wasConnected && isConnected,
              viewModel.items.value.isEmpty && !currentCategory.isEmpty else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            Task { await self?.viewModel.retryLastRequest() }
        }
    }
    
    static func create(with viewModel: ProductViewModelProtocol, posterService: PosterService) -> ViewController {
        guard let vc = UIStoryboard(name: AppConstants.Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: AppConstants.Storyboard.viewController) as? ViewController else {
            fatalError("Could not instantiate ViewController")
        }
        vc.viewModel = viewModel
        vc.posterService = posterService
        return vc
    }
}

// MARK: - UITableView DataSource & Delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AppConstants.CellIdentifiers.categoriesTableViewCell,
                for: indexPath
            ) as? CategoriesTableViewCell else {
                return UITableViewCell()
            }
            
            cell.onCategorySelected = { [weak self] categoryName, _ in
                self?.loadProductsForCategory(categoryName)
            }
            
            if currentCategory.isEmpty && categories.count > 0 {
                DispatchQueue.main.async {
                    cell.selectFirstCategory()
                }
            }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellIdentifiers.productCell, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        cell.configureData(products: viewModel.items.value[indexPath.row], posterRepo: posterService)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 1 else { return }
        
        viewModel.didSelectRowAt(index: indexPath.row)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        guard offsetY > contentHeight - height - 100,
              !isLoadingMore && !viewModel.isLoader.value else { return }
        
        isLoadingMore = true
        Task {
            await viewModel.didLoadNextPage()
        }
    }
}

extension UIViewController {
    func showErrorAlert(error: NetworkError, retryAction: @escaping () -> Void) {
            let alert = UIAlertController(
                title: error.title,
                message: error.message,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: AppConstants.ButtonTitles.tryAgain, style: .default) { _ in
                retryAction()
            })
            alert.addAction(UIAlertAction(title: AppConstants.ButtonTitles.cancel, style: .cancel))
            
            present(alert, animated: true)
        }
    
    
    func showNoDataAlert() {
            let alert = UIAlertController(
                title: AppConstants.AlertTitles.noData,
                message: AppConstants.AlertMessages.noProductsAvailable,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: AppConstants.ButtonTitles.ok, style: .default))
            present(alert, animated: true)
        }
}
