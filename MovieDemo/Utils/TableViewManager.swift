//
//  BindingTableView.swift
//  test
//
//  Created by Oscar Vernis on 7/5/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

protocol ConfigurableCell where Self: UITableViewCell {
    func configureCell(source: Any)
}

class TableViewManager<T: Any>: NSObject, UITableViewDelegate, UITableViewDataSource {
    var source = [T]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var tableView: UITableView
    
    private var cellIdentifier: String?
    
    private var cellCreationHandler: ((T, IndexPath) -> UITableViewCell)?
    private var cellConfigurationHandler: ((UITableViewCell, T, IndexPath) -> ())?
    
    private var didSelectHandler: ((IndexPath) -> ())?
    
    var allowsDeletion: Bool = false
    var allowsDeletionWhileEditing:Bool = true
    private var canEditRowHandler: ((IndexPath) -> Bool)?
    
    init(tableView: UITableView, source: [T]) {
        self.tableView = tableView
        self.source = source
        
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @discardableResult func configureCell(handler: @escaping (T, IndexPath) -> UITableViewCell) -> TableViewManager {
        cellCreationHandler = handler
        
        tableView.reloadData()
        
        return self
    }
    
    @discardableResult func configureCell(withIdentifier: String, handler: ((UITableViewCell, T, IndexPath) -> ())? = nil) -> TableViewManager {
        cellConfigurationHandler = handler
        cellIdentifier = withIdentifier
        
        tableView.reloadData()
        
        return self
    }
    
    func registerCell(_ cellClass: ConfigurableCell.Type) {
        
    }
    
    @discardableResult func didSelect(handler: @escaping (IndexPath) -> ()) -> TableViewManager {
        didSelectHandler = handler
        
        return self
    }
    
    @discardableResult func canEditRow(handler: @escaping (IndexPath) -> Bool) -> TableViewManager {
        canEditRowHandler = handler
        
        return self
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = cellCreationHandler?(source[indexPath.row], indexPath) {
            return cell
        }
        
        if let identifier = cellIdentifier, cellConfigurationHandler == nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConfigurableCell else {
                fatalError("Cell class does not conform to 'ConfigurableCell' protocol.")
            }
            
            cell.configureCell(source: source[indexPath.row])
            
            return cell
        }
        
        if let identifier = cellIdentifier {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            cellConfigurationHandler?(cell!, source[indexPath.row], indexPath)
            
            return cell!
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, commit commitEditingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if commitEditingStyle == .delete {
            self.source.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return allowsDeletionWhileEditing
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if allowsDeletionWhileEditing && tableView.isEditing {
            return .delete
        } else {
            return .none
        }
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if canEditRowHandler != nil {
            return canEditRowHandler!(indexPath)
        }
        
        if tableView.isEditing {
            return true
        }
        
        return allowsDeletion
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = source[sourceIndexPath.row]
        source.remove(at: sourceIndexPath.row)
        source.insert(movedObject, at: destinationIndexPath.row)
    }
    
    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectHandler?(indexPath)
    }
    
}
