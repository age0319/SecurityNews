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

class MyViewController: UITableViewController,XMLParserDelegate{
    
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentstring = ""
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    let myRefreshControl = UIRefreshControl()

    
    @objc private func refresh(sender: UIRefreshControl){
        startDownload()
        table.reloadData()
        sender.endRefreshing()
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
                self?.startDownload()
              DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.table.reloadData()
              }
        }
        
        table.refreshControl = myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    
    func startDownload(){
        
        self.items = []
        let urls = ["http://www.security-next.com/feed",
                    "http://feeds.trendmicro.com/TM-Securityblog/",
                    "https://rss.itmedia.co.jp/rss/2.0/news_security.xml",
                    "https://ccsi.jp/category/%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9/feed/",
                    "https://www.ipa.go.jp/security/rss/info.rdf",
                    "https://scan.netsecurity.ne.jp/rss/index.rdf",
                    "https://www.lac.co.jp/lacwatch/feed.xml"]
        
        for urlString in urls {
            if let url = URL(string: urlString){
                if let parser = XMLParser(contentsOf: url){
                    self.parser = parser
                    self.parser.delegate = self
                    self.parser.parse()
                }
            }
        }
        
        items = items.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentstring = ""
        if elementName == "item" {
            self.item = Item()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentstring += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title":
            self.item?.title = currentstring
        case "link":
            self.item?.link = currentstring
            self.item?.check_source()
        case "pubDate":
            self.item?.convert_pubdate_date(currentString: currentstring)
            self.item?.convert_date_to_string()
        case "dc:date":
            self.item?.convert_dcdate_date(currentString: currentstring)
            self.item?.convert_date_to_string()
        case "item":
            self.items.append(self.item!)
        default:
            break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
    
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
