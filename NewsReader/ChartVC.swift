//
//  ChartVC.swift
//  NewsReader
//
//  Created by haru on 2020/06/05.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import Charts

class ChartVC: UIViewController {
    
    @IBOutlet weak var barcht: BarChartView!
    @IBOutlet weak var piecht: PieChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarCht()
        setPieCht()
    }
    
    func setBarCht(){
        var entry = [ChartDataEntry]()
        
        for (i,d) in unitsSold.enumerated(){
            entry.append(BarChartDataEntry(x: Double(i),y: d))
        }
        
        let dataset = BarChartDataSet(entries: entry,label: "Units Sold")
        dataset.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        barcht.data = BarChartData(dataSet: dataset)
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter()
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
        var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]

        // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return months[Int(value)]
        }
    }
    
    func setPieCht(){
        
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<months.count {
            dataEntries.append( PieChartDataEntry(value: unitsSold[i], label: months[i], data: unitsSold[i]))
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")

        var colors: [UIColor] = []

        for _ in 0..<months.count {
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
    
}
