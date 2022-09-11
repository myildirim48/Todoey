//
//  CategoryViewController.swift
//  Todoey
//
//  Created by YILDIRIM on 10.09.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(.mint)
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if textfield.text != "" {
                let newCategory = Category()
                newCategory.name = textfield.text!
                newCategory.color = UIColor.randomFlat().hexValue()
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let currentCategoryOnCell = categories?[indexPath.row]{
        cell.textLabel?.text = currentCategoryOnCell.name ?? "No Categories Added Yet"
        cell.backgroundColor = UIColor(hexString: currentCategoryOnCell.color ?? "")
        }
        return cell
    }
    
   
    //MARK: - TableView Delegate Methods
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
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write({
                    self.realm.delete(categoryForDeletion) //Deleting data with realm
                    
                })
            }catch{
                print("Error deleting the category \(error)")
            }
        }
    }
    
}
