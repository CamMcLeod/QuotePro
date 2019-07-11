//
//  APIRequest.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkerType {
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
}

enum APIError: Error {
    case badURL
    case requestError
    case invalidJSON
    case invalidImage
}


class APIRequest {
    var networker: NetworkerType
    
    init(networker: NetworkerType) {
        self.networker = networker
    }
}

/// Methods that should be called by other classes
extension APIRequest {
    
    func getRandomPhoto(width:Int, height: Int, requestCompletionHandler: @escaping (UIImage?, Error?) -> Void) {
        guard let url = buildLoremPixelURL(width: width, height: height) else {
            requestCompletionHandler(nil, APIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            
            var resultImage: UIImage
            do {
                resultImage = try self.imageObject(fromData: data, response: urlRequest, error: error)
            } catch let error {
                requestCompletionHandler(nil, error)
                return
            }
            
            requestCompletionHandler(resultImage, nil)
        }
    }
    
    func getRandomQuote(requestCompletionHandler: @escaping (Quote?, Error?) -> Void) {
        guard let url = buildForismaticURL() else {
            requestCompletionHandler(nil, APIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            
            var resultQuote : Quote
            let decoder = JSONDecoder()
            
            guard let data = data else {
                requestCompletionHandler(nil, APIError.invalidJSON)
                return
            }
            
            do {
                resultQuote = try decoder.decode(Quote.self, from: data)
            } catch {
                requestCompletionHandler(nil, APIError.invalidJSON)
                return
            }
            
            requestCompletionHandler(resultQuote, nil)

        }
    }
    
}

/// URL
extension APIRequest {
    
    func buildLoremPixelURL(width: Int, height: Int) -> URL? {
        var componenets = URLComponents()
        componenets.scheme = "https"
        componenets.host = "lorempixel.com"
        var componentsURL = componenets.url
        componentsURL = componentsURL?.appendingPathComponent(String(width))
        componentsURL = componentsURL?.appendingPathComponent(String(height))
        
        return componentsURL
    }
    
    func buildForismaticURL() -> URL? {
        
        var componenets = URLComponents()
        componenets.scheme = "https"
        componenets.host = "api.forismatic.com"
        var componentsURL = componenets.url
        componentsURL = componentsURL?.appendingPathComponent("?method=getQuote&lang=en&format=json")

        return componentsURL
    }
}

/// JSON Parsing
extension APIRequest {
    
    func jsonObject(fromData data: Data) throws -> [String: Any] {
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let results = jsonObject as? [String: Any] else {
            throw APIError.invalidJSON
        }
        
        return results
    }
    
    func imageObject(fromData data: Data) throws -> UIImage {
        
        guard let imageObject = UIImage.init(data: data) else {
            throw APIError.invalidImage
        }
        
        return imageObject
    }
    
    func jsonObject(fromData data: Data?, response: URLResponse?, error: Error?) throws -> [String: Any] {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw APIError.requestError
        }
        
        return try jsonObject(fromData: data)
    }
    
    func imageObject(fromData data: Data?, response: URLResponse?, error: Error?) throws -> UIImage {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw APIError.requestError
        }
        
        return try imageObject(fromData: data)
    }
    
}
