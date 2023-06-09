//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vitali Martsinovich on 2023-03-28.
//

import UIKit
import RealmSwift
import ChameleonSwift

class CategoryViewController: SwipeTableViewController {
    
    //initializing new realm
    lazy var realm = try! Realm()
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
//        navBar.backgroundColor = UIColor(hexString: "32ADE6")
//        navBar.standardAppearance.backgroundColor = UIColor(hexString: "32ADE6")
        navBar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: "32ADE6")
    }
    
    //MARK: -  Add New Categories
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { [self] (action) in
            if alert.textFields?[0].text != "" {
                
                let newCategory = Category()
                newCategory.name = (alert.textFields?[0].text)!
                newCategory.colour = UIColor.randomFlat().hexValue()
                
                self.saveToRealm(category: newCategory)
                
            } else {
                let errorAlert = UIAlertController(title: "Please enter category name", message: "", preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "Ok", style: .default)
                errorAlert.addAction(errorAction)
                self.present(errorAlert, animated: true)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name

            guard let categoryColour = UIColor(hexString: category.colour) else { fatalError() }
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    
    func saveToRealm(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // delete from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error")
            }
        }
    }
}
