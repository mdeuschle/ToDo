//
//  ViewController.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/10/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class ToDoTableVC: UITableViewController {

    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configBarButtonItem()
    }

    private func configBarButtonItem() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = button
    }

    @objc private func addButtonTapped() {
        Alert(viewController: self).addAlert { textField in
            if let textFieldText = textField.text {
                if let item = Item(name: textFieldText) {
                    self.items.append(item)
                    self.tableView.reloadData()
                }
            }
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
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

