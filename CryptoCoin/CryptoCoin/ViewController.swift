//
//  ViewController.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import UIKit

final class ViewController: UIViewController {
    
    var viewModel: ViewModel!
    var activityIndicator: UIActivityIndicatorView?
    var collectionViewHeightConstraint: NSLayoutConstraint?
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1)
        collectionView.register(CoinFilterCollectionViewCell.self, forCellWithReuseIdentifier: CoinFilterCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private lazy var coinnSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func loadView() {
        super.loadView()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Coin"
        viewModel = ViewModel(delegate: self, networManager: NetworkManager())
        viewModel?.fetchCoins()
        showLoader()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showLoader() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.style = .large
        activityIndicator?.startAnimating()
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator!)
        activityIndicator?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: coinnSearchBar.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        // Add constraints for the collection view
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint?.isActive = true
    }
    
    func setupSearchBar() {
        view.addSubview(coinnSearchBar)
        coinnSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinnSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            coinnSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            coinnSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    func setupErrorLabel(text: String) {
        view.addSubview(errorLabel)
        errorLabel.text = text
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewHeightConstraint?.constant = collectionView.contentSize.height + 20
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight - (collectionViewHeightConstraint?.constant ?? 0), right: 0)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let coinFilterModel = viewModel.coinFilterArray[indexPath.item]
        let font = UIFont.systemFont(ofSize: 15)
        let size = (coinFilterModel.title as NSString).size(withAttributes: [.font: font])
        let width = size.width + (coinFilterModel.isSelected ? 30.0 : 0) + 20
        return CGSize(width: width, height: 32)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.coinFilterArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinFilterCollectionViewCell.identifier, for: indexPath) as? CoinFilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.coinFilterArray[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.updateFilterSelection(selectedIndex: indexPath.row)
        collectionView.reloadData()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCoinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.reuseIdentifier) as! CoinTableViewCell
        cell.configureCell(model: viewModel.currentCoinList[indexPath.row])
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        viewModel.filterListForSearch(text: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: ViewModelDelegate {
    
    func coinListFetchedSuccess(list: [CoinModel]) {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true
            self?.setupCollectionView()
            self?.setupSearchBar()
            self?.setupTableView()
        }
    }
    
    func coinListFetchedFail(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true
            self?.setupErrorLabel(text: error)
        }
    }
    
    func updateList() {
        tableView.reloadData()
    }
}
