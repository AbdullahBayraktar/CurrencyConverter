//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 02/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

typealias RequestCompletion = (Data?, Error?) -> Void

class NetworkManager: NSObject {

    private enum Constant {
        static let url = "https://revolut.duckdns.org/latest"
        static let baseParameterKey = "base"
    }

    /// URL session
    private lazy var urlSession: URLSession = {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: self,
                                    delegateQueue: nil)
        return urlSession
    }()

    /// Makes request
    public func sendRequest(
        baseCurrency: String,
        completion: @escaping RequestCompletion) {

        guard let url = URL(string: Constant.url) else {
            return
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: Constant.baseParameterKey, value: baseCurrency)]

        guard let actualUrl = components?.url else {
            return
        }
        let urlRequest = URLRequest(url: actualUrl)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            return completion(data, error)
        }
        dataTask.resume()
    }
}

// MARK: - URLSessionDelegate

extension NetworkManager: URLSessionDelegate {}
