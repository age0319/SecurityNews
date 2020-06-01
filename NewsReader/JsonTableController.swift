//
//  JSONTableController.swift
//  NewsReader
//
//  Created by haru on 2020/06/01.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

class JsonTableCell: UITableViewCell {
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var articletitleLabel: UILabel!
    @IBOutlet weak var articletextLabel: UILabel!
    
}


class JsonTableController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "JsonCell",
                                                   for: indexPath) as! JsonTableCell
          return cell
      }
}
