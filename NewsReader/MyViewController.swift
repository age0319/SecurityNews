//
//  MyViewController.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit


class MyViewController: UITableViewController, ArticleCellDelegate,UISearchBarDelegate{

    func didReadLator(title: String) {
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    let myRefreshControl = UIRefreshControl()
    var items = [Item]()
    var currentItems = [Item]()
    
    func setupSearchBar(){
        search.delegate = self
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        spinner.startAnimating()
        let globalQueue = DispatchQueue.global(
                      qos: DispatchQoS.QoSClass.userInitiated)
              globalQueue.async { [ weak self] in
                let data = MyParse().startDownload()
              DispatchQueue.main.async {
                self?.items = data
                self?.currentItems = data
                self?.spinner.stopAnimating()
                self?.table.reloadData()
              }
        }
        
        table.refreshControl = myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    @objc private func refresh(sender: UIRefreshControl){
        
        let globalQueue = DispatchQueue.global(
            qos: DispatchQoS.QoSClass.userInitiated)
        globalQueue.async { [ weak self] in
            let data = MyParse().startDownload()
            DispatchQueue.main.async {
                self?.items = data
                self?.table.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    
    func reloadCell(index: IndexPath) {
        tableView.reloadRows(at: [index], with: .fade)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow{
            let item = items[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = item.title
            controller.link = item.link
        }else{
            let controller = segue.destination as!
                FavoriteViewController
            
            var favitems = [Item]()
            for i in items{
                if i.isFavorite{
                    favitems.append(i)
                }
            }
            controller.items = favitems
        }
    }
    
}
