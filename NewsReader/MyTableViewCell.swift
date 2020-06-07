//
//  MyTextViewCell.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/27.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleCellDelegate {
    func reloadCell(index: IndexPath)
}

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleSourceLabel: UILabel!
    @IBOutlet weak var favorateButton: UIButton!
    
    //delegateの関数はViewContrtrollerに記載されている
    var delegte: ArticleCellDelegate?
    var item:Item!
    var index:IndexPath!
    
    func setArticle(item: Item){
        self.item = item
        articleTitleLabel?.text = item.title
        articleDateLabel?.text = item.dateString
        articleSourceLabel?.text = item.source
    }
    
    @IBAction func touch(_ sender: Any) {
        
        self.item.isFavorite = !self.item.isFavorite
        
        var items = CommonSetting().loadItems(key: "fav")
        
        if self.item.isFavorite{
            items.append(self.item)
        }else{
            items = items.filter({ item -> Bool in
                !item.title.contains(self.item.title)
            })
        }
        
        CommonSetting().saveItems(items: items, key: "fav")
        
        delegte?.reloadCell(index: index)
        
    }
    
}
