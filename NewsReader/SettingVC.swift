//
//  SummaryVC.swift
//  NewsReader
//
//  Created by haru on 2020/06/04.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import UIKit
import Charts

class SettingCell: UITableViewCell {
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var siteURL: UILabel!
    
}

class SettingVC: UITableViewController{
    
    var dataSource = [Source]()
    
    @IBAction func onRestore(_ sender: Any) {
        dataSource = CommonSetting().setDefaultSetting()
        CommonSetting().saveSourceArray(obj: dataSource, key: "source")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        dataSource = CommonSetting().loadSourceArray(key: "source")
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath:IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view,completion) in
            self.dataSource.remove(at: indexPath.row)
            CommonSetting().saveSourceArray(obj: self.dataSource, key: "source")
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        })
        
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash")
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        cell.siteName.text = dataSource[indexPath.row].name
        cell.siteURL.text = dataSource[indexPath.row].url
        return cell
    }
    
}
