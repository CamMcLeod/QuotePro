//
//  QuoteView.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit

class QuoteView: UIView {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    
    func setupWithQuote(quoteObject: QuoteObject) {
        
        quoteLabel.text = quoteObject.quote.quoteText
        authorLabel.text = quoteObject.quote.quoteAuthor
        photoImage.image = quoteObject.photo.image
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
