//
//  MyViewController.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController, ArticleCellDelegate,UISearchBarDelegate{
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    var items = [Item]()
    var currentItems = [Item]()
    
    func setupSearchBar(){
        search.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentItems = items
        case 1:
            currentItems = items.filter({ item -> Bool in
                item.title.lowercased().contains("android")
            })
        case 2:
            currentItems = items.filter({ item -> Bool in
                item.title.lowercased().contains("ios")
            })
        case 3:
            currentItems = items.filter({ item -> Bool in
                item.title.lowercased().contains("iot")
            })
        case 4:
            currentItems = items.filter({ item -> Bool in
                item.title.lowercased().contains("windows")
            })
        case 5:
            currentItems = items.filter({ item -> Bool in
                item.title.lowercased().contains("linux")
            })
        default:
            break
        }
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentItems = items
            table.reloadData()
            return
        }
        currentItems = items.filter({ item -> Bool in
            item.title.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    //Enterを押した時にキーボードが消えるようにする。
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.search.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
      
        let row_item = currentItems[indexPath.row]
        cell.setArticle(item: row_item)
        cell.delegte = self
        cell.index = indexPath
        
        cell.favorateButton.tintColor = row_item.isFavorite ? UIColor.red : .lightGray
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        download()
    }
    
    @IBAction func onRefresh(_ sender: Any) {
        download()
    }
    
    func download(){
        let dispatchGroup = DispatchGroup()
        let handler = XMLHandler()

        dispatchGroup.enter()
        handler.downloadPararrel(completion: { returnData in
          let data = returnData!
          CommonSetting().saveItems(items: data, key: "secArt")
          dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: .main) {
            self.items = CommonSetting().loadItems(key: "secArt")
            self.currentItems = self.items
            self.tableView.reloadData()
        }
    }
    
    
    func reloadCell(index: IndexPath) {
        tableView.reloadRows(at: [index], with: .fade)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let indexPath = self.tableView.indexPathForSelectedRow{
            let item = currentItems[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = item.title
            controller.link = item.link
        }
    }
}
