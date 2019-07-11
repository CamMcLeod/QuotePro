//
//  Quote.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation

struct Quote: Codable{
    
    var quoteText: String
    var quoteAuthor: String
    
}

class QuoteObject {
    
    let quote : Quote
    let photo : Photo
    
    init(quote: Quote, photo: Photo) {
        self.quote = quote
        self.photo = photo
    }
    
}
