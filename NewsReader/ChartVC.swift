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
        
        var countList = Array(repeating: 0.0, count: categoryList.count)
        
        timeLabel.text = "セキュリティニュースの数（"+items.last!.dateString + "~" + items.first!.dateString + ")"
        
        for (i,category) in categoryList.enumerated(){
            let filtereditems = items.filter({ item -> Bool in
                item.title.lowercased().contains(category.lowercased())
            })
            let numberOfArticle = filtereditems.count
            countList[i] = Double(numberOfArticle)
        }
        
        setBarCht(xLabel: categoryList, yData:countList)
        setPieCht(xLabel: categoryList, yData:countList)
    }

    
    func setBarCht(xLabel:[String],yData:[Double]){
        var entry = [ChartDataEntry]()
        
        for (i,d) in yData.enumerated(){
            if d == 0.0{
                continue
            }
            entry.append(BarChartDataEntry(x: Double(i),y: d))
        }
        
        let dataset = BarChartDataSet(entries: entry)
        dataset.colors = [.systemBlue]
        dataset.drawValuesEnabled = false
        
        barcht.data = BarChartData(dataSet: dataset)
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter(xlabel: xLabel)
        barcht.xAxis.valueFormatter = xaxis.valueFormatter
        
        // Y座標の値が0始まりになるように設定
        barcht.leftAxis.axisMinimum = 0.0
        barcht.leftAxis.drawZeroLineEnabled = true
        barcht.leftAxis.zeroLineColor = .systemGray
        // ラベルの色を設定
        barcht.leftAxis.labelTextColor = .systemGray
        // グリッドの色を設定
        barcht.leftAxis.gridColor = .systemGray
        // 軸線は非表示にする
        barcht.leftAxis.drawAxisLineEnabled = false

        // x軸のラベルをボトムに表示
        barcht.xAxis.labelPosition = .bottom
        // X軸のラベルの色を設定
        barcht.xAxis.labelTextColor = .systemGray
        // X軸の線、グリッドを非表示にする
        barcht.xAxis.drawGridLinesEnabled = false
        barcht.xAxis.drawAxisLineEnabled = false

        // グラフの棒をニョキッとアニメーションさせる
        barcht.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // 右側のyラベル表示をなしにする
        barcht.rightAxis.enabled = false
        
        //凡例を消す
        barcht.legend.enabled = false
        
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter{
        
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

        for (i,d) in yData.enumerated() {
            if d == 0.0{
                continue
            }
            dataEntries.append( PieChartDataEntry(value: yData[i], label: xLabel[i], data: yData[i]))
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "nothig")

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
        
        piecht.legend.enabled = false
        
    }
    
}
