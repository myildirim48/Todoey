//
//  CategoryViewController.swift
//  Todoey
//
//  Created by YILDIRIM on 10.09.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if textfield.text != "" {
                let newCategory = Category()
                newCategory.name = textfield.text!
                
                self.saveCategories(category: newCategory)
            }
        }
        //Alert Textfield
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category Name"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.textLabel?.text = category
        return cell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if segue.identifier == "goToItems"{
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            } //
        }
        
    }
    //MARK: - Data Manipulation Methods
    func saveCategories(category: Category){
        do{
            try realm.write({
                realm.add(category)
            })
        }catch{
            print("Error saving context\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
   
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    

}
