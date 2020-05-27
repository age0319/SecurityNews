//
//  MyViewController.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit


class MyViewController: UITableViewController, ArticleCellDelegate{
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    
    let myRefreshControl = UIRefreshControl()
    var items = [Item]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        cell.setArticle(item: items[indexPath.row])
        cell.delegte = self
        
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
    
    // プロトコルに批准して処理を記載。実行はCell内のお気に入りボタンがタッチされた時。
    func didReadLator(title: String) {
           print(title)
           let alertTitle = "Watch Later"
           let message = "\(title) added to Watch Later List"
           
           let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
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
