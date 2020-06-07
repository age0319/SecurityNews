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
    
    @IBAction func onAction(_ sender: Any) {

        var links = [String]()
        
        for i in items{
            links.append(i.getLink())
        }
        let controller = UIActivityViewController(activityItems: links, applicationActivities: nil)
        self.present(controller,animated: true, completion: nil)
    }
    
    
    @IBAction func onTrash(_ sender: Any) {
        CommonSetting().trashItems(key: "fav")
        items = []
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell",
                                                 for: indexPath) as! FavoriteViewCell
        cell.favoriteTitle.text = items[indexPath.row].title
        return cell
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        items = CommonSetting().loadItems(key: "fav")
        tableView.reloadData()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let indexPath = self.tableView.indexPathForSelectedRow{
               let item = items[indexPath.row]
               let controller = segue.destination as! DetailViewController
               controller.title = item.title
               controller.link = item.link
           }
    }
    
//    func loadFavs() -> [Item]{
//        if let data = UserDefaults.standard.data(forKey: "key"){
//            return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Item]
//        }else{
//            let items = [Item]()
//            return items
//        }
//    }
//
//    func trashFavs(){
//        UserDefaults.standard.removeObject(forKey: "key")
//        items = []
//        tableView.reloadData()
//    }
}

