//
//  QuoteBuilderViewController.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit
import os.log

protocol QuoteObjectDelegate {
    func saveQuoteObject(quoteObject : QuoteObject?)
}

class QuoteBuilderViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var quoteViewContainer: UIView!
    
    var networkManager: NetworkerType = NetworkManager()
    var delegate : QuoteObjectDelegate?
    /*
     this value is constructed as part of adding a new quote
     */
    var quoteView : QuoteView?
    var quoteObject : QuoteObject?
    var quote : Quote?
    var photo : Photo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: [:]), let view = objects.first {
            
            quoteView = view as? QuoteView
            quoteViewContainer.addSubview(quoteView!)
            quoteView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
            
        }
        
    }
    //MARK: Actions
    @IBAction func newQuote(_ sender: Any) {
        
        let quoteAPI = APIRequest(networker: networkManager)
        
        quoteAPI.getRandomQuote { (quote, error) in
            if let error = error {
                print("Error: \(error)")
            }
            guard let quote = quote else {
                print("Error getting quote")
                return
            }
            self.quote = Quote(quoteText: quote.quoteText, quoteAuthor: quote.quoteAuthor)
            DispatchQueue.main.async {
                self.quoteView?.authorLabel.text = quote.quoteAuthor
                self.quoteView?.quoteLabel.text = quote.quoteText
            }
        }
        
    }
    
    @IBAction func newPhoto(_ sender: Any) {
        
        let photoAPI = APIRequest(networker: self.networkManager)
        
        photoAPI.getRandomPhoto(width: Int(self.view.frame.width), height: Int(self.view.frame.width)) { (photo, error) in
            if let error = error {
                print("Error: \(error)")
            }
            guard let photo = photo else {
                print("Error getting photo")
                return
            }
            self.photo = Photo(width: photo.width, height: photo.height, image: photo.image)
            DispatchQueue.main.async {
                self.quoteView?.photoImage.image = photo.image
            }
        }
        
    }
    
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        // Configure the delegate only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if delegate != nil {
            if let saveQuote = quote, let savePhoto = photo {
                quoteObject = QuoteObject(quote: saveQuote, photo: savePhoto)
                delegate?.saveQuoteObject(quoteObject: quoteObject)
            }
            
        }
        
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            self.quoteObject = nil
            return
        }
        
    }
    
}

