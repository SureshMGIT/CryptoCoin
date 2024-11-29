//
//  ViewModel.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import Foundation

class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    let coinFilterArray = [CoinFilterModel(title: "Active Coins"),
                          CoinFilterModel(title: "Inactive Coins"),
                          CoinFilterModel(title: "Only Tokens"),
                          CoinFilterModel(title: "Only Coins"),
                          CoinFilterModel(title: "New Coins")]
    
    init(delegate: ViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func fetchCoins() {
        NetworkManager().fetchCoins() {[weak self] result in
            switch result {
            case .success(let list):
                self?.delegate?.coinListFetchedSuccess(list: list)
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol ViewModelDelegate: AnyObject {
    func coinListFetchedSuccess(list: [CoinModel])
    func coinListFetchedFail()
}
