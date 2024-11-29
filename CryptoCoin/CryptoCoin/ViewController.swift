//
//  ViewController.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: ViewModel!
    var activityIndicator: UIActivityIndicatorView?
    
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
        viewModel = ViewModel(delegate: self)
        viewModel?.fetchCoins()
        showLoader()
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
        
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        // Add constraints for the collection view
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            collectionView.collectionViewLayout.invalidateLayout()
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
        var model = viewModel.coinFilterArray[indexPath.row]
        model.isSelected = !model.isSelected
        viewModel.coinFilterArray[indexPath.row] = model
        collectionView.reloadData()
    }
}

extension ViewController: ViewModelDelegate {
    
    func coinListFetchedSuccess(list: [CoinModel]) {
        print(list)
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true
            self?.setupCollectionView()
        }
    }
    
    func coinListFetchedFail() {
        
    }
}
