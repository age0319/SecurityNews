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
}

class MyViewController: UITableViewController,XMLParserDelegate{
    
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentstring = ""
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        cell.articleTitleLabel?.text = items[indexPath.row].title
        cell.articleDateLabel?.text = items[indexPath.row].dateString
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDownload()
    }
    
    func startDownload(){
        self.items = []
        let urls = ["http://www.security-next.com/feed",
                    "http://feeds.trendmicro.com/TM-Securityblog/",
                    "https://rss.itmedia.co.jp/rss/2.0/news_security.xml"]
        
        for i in 0 ..< urls.count {
            if let url = URL(
                string: urls[i]){
                if let parser = XMLParser(contentsOf: url){
                    self.parser = parser
                    self.parser.delegate = self
                    self.parser.parse()
                }
            }
        }
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
        case "pubDate":
            self.item?.convert_string_to_date(currentString: currentstring)
            self.item?.convert_date_to_string()
        case "item":
            self.items.append(self.item!)
        default:
            break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        items = items.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        
//        for obj in soted_items {
//            print("Sorted Date: \(obj.date) with title: \(obj.title)")
//        }
        
        self.tableView.reloadData()
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
