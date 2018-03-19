//
//  SwipeTableVC.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/18/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableVC: UITableViewController, SwipeTableViewCellDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SwipeTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        deleteAction.image = #imageLiteral(resourceName: "delete-icon")
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }

    func updateModel(at indexPath: IndexPath) { }
}

