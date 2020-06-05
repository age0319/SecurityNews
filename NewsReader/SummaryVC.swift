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

class SummaryCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
}

class SummaryVC: UITableViewController{
    
    
    var categoryList = ["Android",
                        "iOS",
                        "Windows",
                        "Mac",
                        "Linux",
                        "IE",
                        "FireFox",
                        "Safari",
                        "Chrome",
                        "Edge"]
    
    var items = [Item]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
           
            cell.categoryLabel?.text = categoryList[indexPath.row]
            cell.numberLabel?.text = String(0)
            
            return cell
       }
    
    func download(){
          let handler = XMLHandler()
          handler.downloadPararrel(completion: { returnData in
              if let returnData = returnData {
                  self.items = self.sortAndFilter(pureData: returnData)
             }
          })
      }
 
    func sortAndFilter(pureData:[Item])->[Item]{
        var arrangedData = [Item]()
        
        arrangedData = pureData.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        
        arrangedData = arrangedData.filter({ item -> Bool in
            !item.title.contains("最新記事一覧")
        })
        
       arrangedData = arrangedData.filter({ item -> Bool in
            if item.source.contains("Gigazine"){
                return item.subject.contains("セキュリティ")
            }else{
                return true
            }
        })
        
        return arrangedData
    }
    
    func countArticle(){
//        for category in categoryArray{
//            var filtereditems = items.filter({ item -> Bool in
//                item.title.lowercased().contains(category.lowercased())
//            })
//            numberOfArticle = filtereditems.count
//        }
    }
}
