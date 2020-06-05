//
//  ChartVC.swift
//  NewsReader
//
//  Created by haru on 2020/06/05.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import Charts

protocol MyDelegate{
     func didFetchData(data:[Item])
}

class ChartVC: UIViewController,MyDelegate {
    
    @IBOutlet weak var barcht: BarChartView!
    @IBOutlet weak var piecht: PieChartView!
    
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
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
    
    var countList = Array(repeating: 0, count: 10)
    
    var items = [Item]()
    
    func didFetchData(data: [Item]) {
        print(data.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countArticle()
        setBarCht(xLabel: months, yData:unitsSold)
        setPieCht(xLabel: months, yData:unitsSold)
    }
    
    func setBarCht(xLabel:[String],yData:[Double]){
        var entry = [ChartDataEntry]()
        
        for (i,d) in yData.enumerated(){
            entry.append(BarChartDataEntry(x: Double(i),y: d))
        }
        
        let dataset = BarChartDataSet(entries: entry,label: "Units Sold")
        dataset.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        barcht.data = BarChartData(dataSet: dataset)
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter(xlabel: xLabel)
        barcht.xAxis.valueFormatter = xaxis.valueFormatter

        // x軸のラベルをボトムに表示
        barcht.xAxis.labelPosition = .bottom

        // グラフの背景色
        barcht.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        // グラフの棒をニョキッとアニメーションさせる
        barcht.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter{
        // x軸のラベル
//        var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        var xLabel = [String]()
        
        public init(xlabel:[String]) {
            super.init()
            self.xLabel = xlabel
        }
        
        // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return xLabel[Int(value)]
        }
    }
    
    func setPieCht(xLabel:[String],yData:[Double]){
        
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<xLabel.count {
            dataEntries.append( PieChartDataEntry(value: yData[i], label: xLabel[i], data: yData[i]))
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")

        var colors: [UIColor] = []

        for _ in 0..<xLabel.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))

            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }

        pieChartDataSet.colors = colors
        
        piecht.data = PieChartData(dataSet: pieChartDataSet)
        
        piecht.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
    }
    
     func download(){
        let handler = XMLHandler()
        handler.downloadPararrel(completion: { returnData in
        if let returnData = returnData {
            let data = self.sortAndFilter(pureData: returnData)
            self.didFetchData(data: data)
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
        
    func countArticle(){
        download()
        for (i,category) in categoryList.enumerated(){
            let filtereditems = items.filter({ item -> Bool in
                item.title.lowercased().contains(category.lowercased())
            })
            let numberOfArticle = filtereditems.count
            countList[i] = numberOfArticle
        }
    }
    
}
