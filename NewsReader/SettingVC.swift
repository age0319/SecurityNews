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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonSetting().tpl.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let tpl = CommonSetting().tpl
        
        cell.siteName.text = tpl[indexPath.row].0
        cell.siteURL.text = tpl[indexPath.row].1
        
        return cell
    }
    
}
