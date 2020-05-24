//
//  MyViewController.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleSourceLabel: UILabel!
}


class MyViewController: UITableViewController{
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    let myRefreshControl = UIRefreshControl()
    var items = [Item]()

    
    @objc private func refresh(sender: UIRefreshControl){
       
        let globalQueue = DispatchQueue.global(
                             qos: DispatchQoS.QoSClass.userInitiated)
                     globalQueue.async { [ weak self] in
                        let mp = MyParse()
                        let tmp = mp.startDownload()
                     DispatchQueue.main.async {
                        self?.items = tmp
                        self?.table.reloadData()
                        sender.endRefreshing()
                     }
               }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        cell.articleTitleLabel?.text = items[indexPath.row].title
        cell.articleDateLabel?.text = items[indexPath.row].dateString
        cell.articleSourceLabel?.text = items[indexPath.row].source
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        let globalQueue = DispatchQueue.global(
                      qos: DispatchQoS.QoSClass.userInitiated)
              globalQueue.async { [ weak self] in
                let mp = MyParse()
                self?.items = mp.startDownload()
              DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.table.reloadData()
              }
        }
        
        table.refreshControl = myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow{
            let item = items[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = item.title
            controller.link = item.link
        }
    }

}
