//
//  ViewController.swift
//  Todoey
//
//  Created by YILDIRIM on 8.09.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
          didSet {
              loadItems()
          }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
  
        
        if let colourHex = selectedCategory?.color{
            
            title = selectedCategory!.name
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = UIColor(hexString: colourHex)
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
        
            searchBar.barTintColor = UIColor(hexString: colourHex)
           
        }
    }
 
    
    //MARK: - Tableview Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //Creating gardient indexpath / totalItems
            if let colour =  UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
            cell.backgroundColor = colour
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            }
            //Ternary Operator =>
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
            print("asdasda")
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
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
            
                        print("Item added")
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
        
    
        self.tableView.reloadData()
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
       tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(item) //Deleting data with realm
                    
                }
            }catch{
                print("Error deleting the category \(error)")
            }
        }
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
            
            tableView.reloadData()
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
