//
//  TableViewController.swift
//  ToDoList
//
//  Created by Роман Солдатов on 28.03.2022.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    var toDos = [ToDo]()
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
            let sourceViewController = segue.source as!
               ToDoDetailTableViewController

            if let toDo = sourceViewController.toDo {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
        
                toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }

    
    override func tableView(_ tableView: UITableView,
       numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
       indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
           "ToDoCellIdentifier", for: indexPath)
        
    let toDo = toDos[indexPath.row]
    var content = cell.defaultContentConfiguration()
    content.text = toDo.title
    cell.contentConfiguration = content
    return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
       indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit
       editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
       IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
