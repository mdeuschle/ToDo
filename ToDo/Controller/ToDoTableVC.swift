//
//  ViewController.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/10/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableVC: UITableViewController {

    var items = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        configBarButtonItem()
        loadItems()
        configureSearch()
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
            if let textFieldText = textField.text {
                let item = Item(context: self.context)
                item.name = textFieldText
                item.isSelected = false
                self.items.append(item)
                self.saveItems()
            }
        }
    }

    private func saveItems() {
        try? context.save()
        tableView.reloadData()
    }

    private func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch {
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isSelected ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isSelected = !item.isSelected
        //        context.delete(item)
        //        items.remove(at: indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ToDoTableVC: UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS %@", searchController.searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            items = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}

