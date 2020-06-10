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
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstPieCht: PieChartView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondPieCht: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSecCht()
        makeTechCht()
    }
        
    @IBAction func onRefresh(_ sender: Any) {
        makeSecCht()
        makeTechCht()
    }
    
    func makeSecCht(){
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
            self.makeCharts(items: items,category: "セキュリティ")
        }
    }
    
    func makeTechCht(){
        let dispatchGroup = DispatchGroup()
        let handler = JSONHandler()
        
        dispatchGroup.enter()

        handler.download(completion: { returnData in
            let data = returnData!
            CommonSetting().saveItems(items: data, key: "techArt")
            dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: .main) {
            let items = CommonSetting().loadItems(key: "techArt")
            self.makeCharts(items: items,category: "テクノロジー")
        }
    }

    
    func makeCharts(items: [Item], category:String) {
        
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
        
        var sourceList = [String]()
        
        for i in todayItems{
            sourceList.append(i.source)
        }
        
        var counts: [String: Double] = [:]
        sourceList.forEach { counts[$0, default: 0] += 1 }
        
        if category == "セキュリティ"{
            firstLabel.text = "今日の" + category + "ニュース数" + "(" + todayTime + "):" + String(numberOfTodaysArticle)
            firstPieCht.data = setPieCht(stats: counts)
            firstPieCht.legend.enabled = true
        }else if category == "テクノロジー"{
            secondLabel.text = "今日の" + category + "ニュース数" + "(" + todayTime + "):" + String(numberOfTodaysArticle)
            secondPieCht.data = setPieCht(stats: counts)
            secondPieCht.legend.enabled = true
        }
        
    }
    
    func setPieCht(stats:[String: Double]) -> PieChartData{
        
        var dataEntries: [ChartDataEntry] = []

        for i in stats {
            dataEntries.append( PieChartDataEntry(value: i.1, label: i.0, data: i.1))
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

        let data = PieChartData(dataSet: pieChartDataSet)
        
        // 最低値を0に（Double→Int）
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            
        return data
                
    }
    
}
