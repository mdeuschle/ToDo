//
//  Alert.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/10/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

struct Alert {

    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func addAlert(textFieldHandler: @escaping (UITextField) -> Void) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add To Do Item",
                                                message: "",
                                                preferredStyle: .alert)
        alertController.addTextField { alertTextField in
            textField = alertTextField
        }
        let alertAction = UIAlertAction(title: "Add",
                                        style: .default) { action in
                                            textFieldHandler(textField)
        }
        alertController.addAction(alertAction)
        viewController.present(alertController,
                               animated: true,
                               completion: nil)
    }
}


