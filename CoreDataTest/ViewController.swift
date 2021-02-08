//
//  ViewController.swift
//  CoreDataTest
//
//  Created by MUHAMMAD ALFARABY on 03/02/21.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
  private var models = [ListItem]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getAllItems()
    // Do any additional setup after loading the view.
  }
  
  //MARK: -  CRUD
  
  
  func getAllItems()  {
    do {
      models = try context.fetch(ListItem.fetchRequest())
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    catch {
      
    }
  }
  
  func createItem(name: String)  {
    let newItem = ListItem(context: context)
    newItem.name = name
    
    do {
      try context.save()
      getAllItems()
    } catch  {
      
    }
    
    
  }
  
  func deleteItem(item: ListItem)  {
    context.delete(item)
    
    do {
      try context.save()
    } catch  {
      
    }
    
  }
  
  func updateItem(item: ListItem, newName: String)  {
    item.name = newName
    do {
      try context.save()
    } catch  {
      
    }
    
  }
  
  
  //MARK: -  tableview setup
  
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = model.name
    return cell
  }
  @IBAction func addPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add Content", message: "", preferredStyle: .alert)
    alert.addTextField { (UITextField) in
    }
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
      guard let content = alert.textFields?.first, let text = content.text, !text.isEmpty else {
        return
      }
      
      //MARK: -  create data to coredata
      
      self.createItem(name: text)
      self.tableView.reloadData()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  //MARK: -  tapped cell to update
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = models[indexPath.row]
    let sheet = UIAlertController(title: "edit", message: nil, preferredStyle: .actionSheet)
    
    sheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
    sheet.addAction(UIAlertAction(title: "edit", style: .default, handler: { _ in
      
      let alert = UIAlertController(title: "Edit Item", message: "Edit your Item", preferredStyle: .alert)
      alert.addTextField { (UITextField) in
      }
      alert.textFields?.first?.text = item.name
      alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { (UIAlertAction) in
        guard let content = alert.textFields?.first, let newName = content.text, !newName.isEmpty else {
          return
        }
        //MARK: -  update data
        self.updateItem(item: item, newName: newName)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
          
        }
        
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
      self.present(alert, animated: true, completion: nil)
      
      
    }))
    //MARK: -  delete from action sheet
    
    sheet.addAction(UIAlertAction(title: "delete", style: .destructive, handler: {_ in
      self.deleteItem(item: item)
      self.getAllItems()
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
        
      }
    }))
    
    self.present(sheet, animated: true)
    
    
    
    
  }
  
  //MARK: -  swipe left to delete
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      //          lists.remove(at: indexPath.row)
      self.deleteItem(item: models[indexPath.row])
      getAllItems()
    }
    DispatchQueue.main.async {
      tableView.reloadData()
      
    }
    
  }
  
  
}

