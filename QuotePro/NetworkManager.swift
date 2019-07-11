//
//  NetworkManager.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation

class NetworkManager: NetworkerType {
    
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = urlSession.dataTask(with: url, completionHandler: requestCompletionHandler)
        dataTask.resume()
    }
    
//    func postRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "POST"
//        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: postCompletionHandler)
//        task.resume()
//
//}
}
