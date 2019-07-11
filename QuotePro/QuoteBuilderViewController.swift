//
//  QuoteBuilderViewController.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit
import os.log

class QuoteBuilderViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    /*
     this value is constructed as part of adding a new quote
     */
    var quoteObject : QuoteObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
            
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The QuoteBuilderViewController is not inside a navigation controller.")
        }
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // Set the quote to be passed to HomeScreenViewController after the unwind segue.
        quoteObject = QuoteObject(quote: <#T##Quote#>, photo: <#T##Photo#>)
    }
    
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
//        let text = nameTextField.text ?? ""
//        saveButton.isEnabled = !text.isEmpty
    }
}

