//
//  ChartVC.swift
//  NewsReader
//
//  Created by haru on 2020/06/05.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import Charts


class ChartVC: UIViewController{
    
    @IBOutlet weak var barcht: BarChartView!
    @IBOutlet weak var piecht: PieChartView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func onRefresh(_ sender: Any) {
        downloadMakeCht()
    }
    var categoryList = ["Android",
                        "iOS",
                        "Windows",
                        "Mac",
                        "Linux",
                        "IE",
                        "FireFox",
                        "Safari",
                        "Chrome",
                        "Edge"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadMakeCht()
    }
    
    func downloadMakeCht(){
        let dispatchGroup = DispatchGroup()
        let handler = XMLHandler()
        
        dispatchGroup.enter()
        handler.downloadPararrel(completion: { returnData in
            let data = returnData!
            CommonSetting().saveItems(items: data, key: "secArt")
            dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: .main) {
            let items = CommonSetting().loadItems(key: "secArt")
            self.makeCharts(items: items)
        }
    }
    
    func makeCharts(items: [Item]) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/HH:mm:ss"
        let todayTime = formatter.string(from: date)

        formatter.dateFormat = "MM/dd"
        let todayDate = formatter.string(from: date)

        let todayItems = items.filter({ item -> Bool in
             item.dateString.contains(todayDate)
         })
        let numberOfTodaysArticle = todayItems.count
        
        timeLabel.text = "今日のセキュリティニュース数" + "(" + todayTime + "):" + String(numberOfTodaysArticle)
        
        let dataSource = CommonSetting().loadSourceArray(key: "source")
        var stats = [(String,Double)]()
        
        for source in dataSource{
            let filtereditems = todayItems.filter({ item -> Bool in
                item.source.contains(source.name)
            })
            let stat = (source.name,Double(filtereditems.count))
            stats.append(stat)
        }
        
        setPieCht(stats: stats)
    }
    
    func setPieCht(stats:[(String,Double)]){
        
        var xLabel = [String]()
        var yData = [Double]()
        
        for i in stats{
            xLabel.append(i.0)
            yData.append(i.1)
        }
        
        var dataEntries: [ChartDataEntry] = []

        for (i,d) in yData.enumerated() {
            if d == 0.0{
                continue
            }
            dataEntries.append( PieChartDataEntry(value: yData[i], label: xLabel[i], data: yData[i]))
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")

        var colors: [UIColor] = []

        for _ in dataEntries {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))

            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }

        pieChartDataSet.colors = colors
        
        piecht.data = PieChartData(dataSet: pieChartDataSet)
        
        piecht.legend.enabled = true
        
    }
    
}
