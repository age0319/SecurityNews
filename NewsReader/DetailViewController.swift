//
//  DetailViewController.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/20.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.link){
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
