//
//  CategoryVC.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/11/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

    private var categories = [Category]()
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
                let category = Category(context: self.context)
                category.cateoryName = textFieldText
                self.categories.append(category)
                self.save()
            }
        }
    }

    private func save() {
        try? context.save()
        tableView.reloadData()
    }

    private func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.cateoryName
        return cell
    }
}