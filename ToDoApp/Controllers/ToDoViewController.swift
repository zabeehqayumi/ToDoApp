//
//  ViewController.swift
//  ToDoApp
//
//  Created by Zabeehullah Qayumi on 9/13/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
 
    var itemArray = [Item]()
    
    // new some lines
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
     
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    
    //MARK:- Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = item.done ==  true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //itemArray[indexPath.row].setValue("New crud operation", forKey: "title")
        
        // deleting operation
//       context.delete(itemArray[indexPath.row])
//       itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // Calling Method
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)

   

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Please add your fav item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //core data context property
            
            let newItem = Item(context: self.context)
            newItem.title = newTextField.text!
            newItem.done = false
            //new line
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            //caling method
            
            self.saveItem()
            
    
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "please type here"
            newTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("Could not encode data \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
// some new changes
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate :NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//
//        request.predicate = compoundPredicate
        
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
            
        }
        
        
            do{
               itemArray =  try context.fetch(request)
            }catch{
                print("Could not laod data : \(error.localizedDescription)")
            }
        tableView.reloadData()
        }
    
}

extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // changes made
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}








