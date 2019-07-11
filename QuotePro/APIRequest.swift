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
//    func postData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
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
    
    func getRandomPhoto(width:Int, height: Int, completionHandler: @escaping (Photo?, Error?) -> Void) {
        guard let url = buildLoremPixelURL(width: width, height: height) else {
            completionHandler(nil, APIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            
            var resultImage: UIImage
            do {
                resultImage = try self.imageObject(fromData: data, response: urlRequest, error: error)
            } catch let error {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(Photo(width: width, height: height, image: resultImage), nil)
        }
    }
    
    func getRandomQuote(completionHandler: @escaping (Quote?, Error?) -> Void) {
        guard let url = buildForismaticURL() else {
            completionHandler(nil, APIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            
            var resultQuote : Quote
            let decoder = JSONDecoder()
            
            guard let data = data else {
                completionHandler(nil, APIError.invalidJSON)
                return
            }
            var json: [String: Any] = [:]
            do {
                resultQuote = try decoder.decode(Quote.self, from: data)
            } catch {
                completionHandler(nil, APIError.invalidJSON)
                return
            }
            
            completionHandler(resultQuote, nil)

        }
    }
    
}

/// URL
extension APIRequest {
    
    func buildLoremPixelURL(width: Int, height: Int) -> URL? {
        var componenets = URLComponents()
        componenets.scheme = "http"
        componenets.host = "lorempixel.com"
        var componentsURL = componenets.url
        componentsURL = componentsURL?.appendingPathComponent(String(width))
        componentsURL = componentsURL?.appendingPathComponent(String(height))
        
        return componentsURL
    }
    
    func buildForismaticURL() -> URL? {
        
        var componenets = URLComponents()
        componenets.scheme = "http"
        componenets.host = "api.forismatic.com"
        
        componenets.queryItems = [
        URLQueryItem(name: "method", value: "getQuote"),
        URLQueryItem(name: "lang", value: "en"),
        URLQueryItem(name: "format", value: "json")
        
        ]
        
        var componentsURL = componenets.url
        componentsURL = componentsURL?.appendingPathComponent("api")
        componentsURL = componentsURL?.appendingPathComponent("1.0/")
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
