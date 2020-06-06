//
//  MyViewController.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController, ArticleCellDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    let myRefreshControl = UIRefreshControl()
    var items = [Item]()
    var currentItems = [Item]()
    
    func setupSearchBar(){
        search.delegate = self
    }
    
    @IBAction func showActivityViewController(_ sender: Any) {
        let favs = loadFavs()
        var links = [String]()
        
        for i in favs{
            links.append(i.getLink())
        }
        
        let controller = UIActivityViewController(activityItems:links ,applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavs()
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        table.refreshControl = myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        items = loadItems()
        currentItems = self.items
        updateFavs()
        table.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl){
        search.selectedScopeButtonIndex = 0;
        downloadAndReload()
        sender.endRefreshing()
    }
    
    func downloadAndReload(){
        let handler = XMLHandler()
        handler.downloadPararrel(completion: { returnData in
            if let returnData = returnData {
                self.items = self.sortAndFilter(pureData: returnData)
                self.currentItems = self.items
                self.updateFavs()
                self.table.reloadData()
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
    
    func loadItems() -> [Item]{
        if let data = UserDefaults.standard.data(forKey: "data"){
            return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Item]
        }else{
            let items = [Item]()
            return items
        }
    }

    func updateFavs(){
           
       let favs = loadFavs()
        
        if favs.isEmpty {
            self.items.forEach { $0.isFavorite = false }
        }else{
           for i in favs{
               if let offset = self.items.firstIndex(where: {$0.title == i.title}) {
                   self.items[offset].isFavorite = true
               }
           }
        }
        
       return
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
