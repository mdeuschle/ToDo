//
//  ViewController.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/10/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoTableVC: SwipeTableVC {

    private var toDoItems: Results<Item>?
    let realm = try! Realm()

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configBarButtonItem()
        loadItems()
        configureSearch()
        tableView.separatorStyle = .none
    }

    private func configureSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func configBarButtonItem() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = button
    }

    @objc private func addButtonTapped() {
        Alert(viewController: self).addAlert { textField in
            if let textFieldText = textField.text, let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textFieldText
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
    }

    private func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            let cgFloat = CGFloat(indexPath.row) / CGFloat(toDoItems!.count)
            if let backgroundColor = UIColor.flatLime.darken(byPercentage: cgFloat) {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func updateModel(at indexPath: IndexPath) {
        if let toDoItems = self.toDoItems {
            do {
                try self.realm.write {
                    self.realm.delete(toDoItems[indexPath.row])
                }
            } catch {
                print(error)
            }
        }
    }
}

extension ToDoTableVC: UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchController.searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        if searchController.searchBar.text!.isEmpty {
            loadItems()
        }
    }
}

