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
    func didReadLator(title: String)
}

class MyTableViewCell: UITableViewCell {
    
    var item:Item!
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleSourceLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!

    //delegateの関数はViewContrtrollerに記載されている
    var delegte: ArticleCellDelegate?
    
    func setArticle(item: Item){
        self.item = item
        articleTitleLabel?.text = item.title
        articleDateLabel?.text = item.dateString
        articleSourceLabel?.text = item.source
    }
    
    @IBAction func touch(_ sender: Any) {
        delegte?.didReadLator(title: self.item.title)
    }
}
