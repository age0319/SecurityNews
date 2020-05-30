//
//  FavoriteViewController.swift
//  NewsReader
//
//  Created by haru on 2020/05/28.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewCell: UITableViewCell {
    @IBOutlet weak var favoriteTitle: UILabel!
}

class FavoriteViewController: UITableViewController{
    
    var items = [Item]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell",
                                                 for: indexPath) as! FavoriteViewCell
        cell.favoriteTitle.text = items[indexPath.row].title
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = loadFavs()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let indexPath = self.tableView.indexPathForSelectedRow{
               let item = items[indexPath.row]
               let controller = segue.destination as! DetailViewController
               controller.title = item.title
               controller.link = item.link
           }
    }
    
    func loadFavs() -> [Item]{
        if let data = UserDefaults.standard.data(forKey: "key"){
            return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Item]
        }else{
            let items = [Item]()
            return items
        }
    }
}

