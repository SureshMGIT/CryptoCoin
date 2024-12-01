//
//  NetworkManager.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    
    func fetchCoins(completionHandler: @escaping (Result<[CoinModel], NetworkError>) -> Void) {
        let urlString = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io"
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.error("Invalid url")))
            return
        }
        let session = URLSession(configuration: .default, delegate: CustomSessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(.error(error.localizedDescription)))
                return
            }
            
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let list = try decoder.decode([CoinModel].self, from: data)
                    completionHandler(.success(list))
                } catch {
                    completionHandler(.failure(.error(error.localizedDescription)))
                }
            }
        }

        task.resume()
    }
}

class CustomSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

enum NetworkError: Error {
    case error(String)
}

protocol NetworkManagerProtocol {
    func fetchCoins(completionHandler: @escaping (Result<[CoinModel], NetworkError>) -> Void)
}
