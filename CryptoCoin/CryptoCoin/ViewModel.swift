//
//  ViewModel.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import Foundation

class ViewModel {
    
    func fetchCoins() {
        NetworkManager().fetchCoins() { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
        }
    }
}
