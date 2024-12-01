//
//  ViewModel.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import Foundation

final class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    var coinFilterArray = [CoinFilterModel(title: "Active Coins"),
                          CoinFilterModel(title: "Inactive Coins"),
                          CoinFilterModel(title: "Only Tokens"),
                          CoinFilterModel(title: "Only Coins"),
                          CoinFilterModel(title: "New Coins")]
    var coinList: [CoinModel] = []
    var listFilter: [CoinModel] = []
    var currentCoinList: [CoinModel] = []
    let networkManager: NetworkManagerProtocol
    
    init(delegate: ViewModelDelegate?, networManager: NetworkManagerProtocol) {
        self.delegate = delegate
        self.networkManager = networManager
    }
    
    func fetchCoins() {
        networkManager.fetchCoins() {[weak self] result in
            switch result {
            case .success(let list):
                self?.coinList = list
                self?.currentCoinList = list
                self?.listFilter = list
                self?.delegate?.coinListFetchedSuccess(list: list)
            case .failure(let error):
                self?.delegate?.coinListFetchedFail(error: error.localizedDescription)
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
                    if innerItem.isSelected && item.type == .coin {
                        return true
                    }
                case "New Coins":
                    if innerItem.isSelected && item.isNew {
                        return true
                    }
                default:
                    break
                }
            }
            return false
        })
        listFilter = array
        currentCoinList = listFilter
    }
    
    func filterListForSearch(text: String) {
        if text.isEmpty {
            currentCoinList = listFilter
            return
        }
        let array = listFilter.filter({ $0.name.lowercased().contains(text.lowercased())})
        currentCoinList = array
    }
}

protocol ViewModelDelegate: AnyObject {
    func coinListFetchedSuccess(list: [CoinModel])
    func coinListFetchedFail(error: String)
    func updateList()
}


