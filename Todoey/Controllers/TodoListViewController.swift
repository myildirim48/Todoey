//
//  ViewController.swift
//  Todoey
//
//  Created by YILDIRIM on 8.09.2022.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Tableview Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //Ternary Operator =>
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write({
//                realm.delete(item) //Deleting data with realm
                item.done = !item.done
            })
            }catch{
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    })
                }catch{
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        //Alert textfield
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    //MARK: -Model Manupulation Methods
    func saveItems(){
        
        //        do{
        //            try context.save()
        //        }catch{
        //            print("Error saving context\(error)")
        //        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //
    //
    //        let request : NSFetchRequest<Item> = Item.fetchRequest()
    //
    //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    //
    //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    //
    //        loadItems(with: request, predicate: predicate)
    //    }
    //
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        if searchBar.text?.count == 0 {
    //            loadItems()
    //
    //            DispatchQueue.main.async {
    //                searchBar.resignFirstResponder()
    //            }
    //
    //        }
    //    }
}
