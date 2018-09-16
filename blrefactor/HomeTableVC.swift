//
//  HomeTableVC.swift
//  blrefactor
//
//  Created by Ashwin Chalaka on 9/15/18.
//  Copyright © 2018 Ashwin Chalaka. All rights reserved.
//

import UIKit

protocol AddEditTableVCDelegate: class {
    func cancelButtonPressed(_ controller: AddEditTableVC, didPressCancelButton button: UIBarButtonItem)
    func addItemViewController(_ controller: AddEditTableVC, didFinishAddingItem item: String, at indexPath: NSIndexPath?)
}

class HomeTableVC: UITableViewController, AddEditTableVCDelegate {
    
    // Define items that go into our main table
    var items: [String] = ["Go to the moon", "Swim in the Amazon", "Ride a motorcycle in Tokyo", "Become a professional iOS Developer", "Finish this section"]
    
    // Execute these commands when the view controller loads for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Dynamic Table setup...
    // (1) - define the number of table cells in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    // (2) - define the values displayed in each table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // Conform to AddEditTableVCDelegate protocol...
    // (1) - What happens to this VC when the "Cancel" button is pressed on the other VC
    func cancelButtonPressed(_ controller: AddEditTableVC, didPressCancelButton button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // (2) - What happens to this VC when the "Save" button is pressed on the other VC
    func addItemViewController(_ controller: AddEditTableVC, didFinishAddingItem item: String, at indexPath: NSIndexPath?) {
        if let path = indexPath {
            items[path.row] = item
        }
        else {
            items.append(item)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ChangeTableSegue", sender: sender)
    }
    
    // Will listen for anytime someone clicks an existing row's "i" (info) button in the table
    // Then this will go through the prepare function below and set up the next VC based on the particular table row that was picked
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ChangeTableSegue", sender: indexPath)
    }
    
    // Enabling functionality "swipe to delete"
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // Required function to prepare for all segues from this controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIBarButtonItem {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddEditTableVC
            controller.delegate = self
        }
        else {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddEditTableVC
            controller.delegate = self
            
            // (a) - save the index information relating the row that is selected
            // (b) - save the contents of the selected row in a variable inside the destination VC
            // (c) - save the contents of the editted row in the correct row index
            let indexPath = sender as! NSIndexPath // (a)
            let item = items[indexPath.row]        // (b)
            controller.selectedItem = item         // (b)
            controller.indexPath = indexPath       // (c)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

