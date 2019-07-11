//
//  MasterViewController.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit
import CoreData
import os.log

class HomeScreenViewController: UITableViewController, NSFetchedResultsControllerDelegate , QuoteObjectDelegate{

    var quotes: [QuoteObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load the sample data.
        loadSampleQuotes()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "QuoteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuoteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of QuoteTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let quoteObject = quotes[indexPath.row]
        
        // Configure the cell...
        cell.textLabel!.text = quoteObject.quote.quoteText
        cell.detailTextLabel!.text = quoteObject.quote.quoteAuthor
        
        
        return cell
    }

 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            quotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let quoteObject = quotes[indexPath.row]
        let image : UIImage?
        if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: [:]), let view = objects.first {
            
            if let quoteView = view as? QuoteView {
                quoteView.frame = CGRect(x: 0, y: 0, width: CGFloat(quoteObject.photo.width), height: CGFloat(quoteObject.photo.height))
                UIGraphicsBeginImageContextWithOptions(CGSize(width: quoteObject.photo.width, height: quoteObject.photo.height), true, 0)
                quoteView.authorLabel.text = quoteObject.quote.quoteAuthor
                quoteView.quoteLabel.text = quoteObject.quote.quoteText
                quoteView.photoImage.image = quoteObject.photo.image
                quoteView.drawHierarchy(in: quoteView.frame, afterScreenUpdates: true)
                self.view.addSubview(quoteView)
                self.navigationController!.setNavigationBarHidden(true, animated: true)
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
                let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                avc.completionWithItemsHandler = { (activity, success, items, error) in
                    self.navigationController!.setNavigationBarHidden(false, animated: true)
                    quoteView.removeFromSuperview()
                    
                }
                

                self.present(avc, animated: true)
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */


    //MARK: Actions
    
    func saveQuoteObject(quoteObject: QuoteObject?) {
        if let newQuoteObject = quoteObject {
            // Add a new quote.
            let newIndexPath = IndexPath(row: quotes.count, section: 0)
            quotes.append(newQuoteObject)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addQuote":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            let quoteBuilder = segue.destination.children[0] as! QuoteBuilderViewController
            quoteBuilder.delegate = self
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    //MARK: Private Methods

    private func loadSampleQuotes() {
        
        let photo1 = UIImage(named: "Image")!
        let photo2 = UIImage(named: "Image-2")!
        let photo3 = UIImage(named: "Image-1")!
        
        let quoteObject1 = QuoteObject(quote: Quote(quoteText: "Cheeseburgers? I haven't had one.", quoteAuthor: "Ronald McDonald"), photo: Photo(width: 500, height: 500, image: photo1))
        
        let quoteObject2 = QuoteObject(quote: Quote(quoteText: "Cheeseburgers? I haven't had one.", quoteAuthor: "Ronald McDonald"), photo: Photo(width: 500, height: 500, image: photo2))
        
        let quoteObject3 = QuoteObject(quote: Quote(quoteText: "Cheeseburgers? I haven't had one.", quoteAuthor: "Ronald McDonald"), photo: Photo(width: 500, height: 500, image: photo3))
        
        quotes += [quoteObject1, quoteObject2, quoteObject3]
        
    }



}

