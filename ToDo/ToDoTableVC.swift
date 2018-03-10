//
//  ViewController.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/10/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class ToDoTableVC: UITableViewController {

    var testArray = ["Buy Eggs", "Play Golf", "Eat Lunch"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = testArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

