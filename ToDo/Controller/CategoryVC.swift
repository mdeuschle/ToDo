//
//  CategoryVC.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/11/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: SwipeTableVC {

    let realm = try! Realm()

    private var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configAddButton()
        loadCategories()
    }

    private func configAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = button
    }

    @objc private func addButtonTapped() {
        Alert(viewController: self).addAlert { textField in
            if let textFieldText = textField.text {
                let category = Category()
                category.name = textFieldText
                self.save(category: category)
            }
        }
    }

    private func save(category: Category) {
        try? realm.write {
            realm.add(category)
        }
        tableView.reloadData()
    }

    private func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let categories = self.categories {
            do {
                try self.realm.write {
                    self.realm.delete(categories[indexPath.row])
                }
            } catch {
                print(error)
            }
        }
    }

    //Mark: Datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }

    //Mark: TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToItems" {
            if let destinationVC = segue.destination as? ToDoTableVC,
                let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}

