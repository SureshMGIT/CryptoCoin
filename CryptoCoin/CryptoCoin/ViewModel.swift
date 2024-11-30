//
//  ViewModel.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import Foundation

class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    var coinFilterArray = [CoinFilterModel(title: "Active Coins"),
                          CoinFilterModel(title: "Inactive Coins"),
                          CoinFilterModel(title: "Only Tokens"),
                          CoinFilterModel(title: "Only Coins"),
                          CoinFilterModel(title: "New Coins")]
    var coinList: [CoinModel] = []
    var currentCoinList: [CoinModel] = []
    
    init(delegate: ViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func fetchCoins() {
        NetworkManager().fetchCoins() {[weak self] result in
            switch result {
            case .success(let list):
                self?.coinList = list
                self?.currentCoinList = list
                self?.delegate?.coinListFetchedSuccess(list: list)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateFilterSelection(selectedIndex: Int) {
        var model = coinFilterArray[selectedIndex]
        model.isSelected = !model.isSelected
        coinFilterArray[selectedIndex] = model
        createCoinListForFilter()
    }
    
    func createCoinListForFilter() {
        let array = coinList.filter({ item in
            for innerItem in coinFilterArray {
                switch innerItem.title {
                case "Active Coins":
                    if innerItem.isSelected && item.isActive {
                        return true
                    }
                case "Inactive Coins":
                    if innerItem.isSelected && !item.isActive {
                        return true
                    }
                case "Only Tokens":
                    if innerItem.isSelected && item.type == .token {
                        return true
                    }
                case "Only Coins":
                    currentCoinList = coinList.filter { $0.type == .coin }
                    if innerItem.isSelected && item.type == .coin {
                        return true
                    }
                case "New Coins":
                    currentCoinList = coinList.filter { $0.isNew }
                    if innerItem.isSelected && item.isNew {
                        return true
                    }
                default:
                    break
                }
            }
            return false
        })
        currentCoinList = array
    }
}

protocol ViewModelDelegate: AnyObject {
    func coinListFetchedSuccess(list: [CoinModel])
    func coinListFetchedFail()
    func updateList()
}


