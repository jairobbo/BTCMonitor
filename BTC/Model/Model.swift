//
//  Model.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 26-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import Foundation

typealias AxisData = [(relativePosition: Double, value: String)]
typealias GraphData = [(relativeXPosition: Double, relativeYPosition: Double)]
typealias GraphInput = [(date: String, value: Double)]

struct GraphModel {
    var axisXData: AxisData = []
    var axisYData: AxisData = []
    var graphData: GraphData = []
    var rawData: GraphInput = []
    
    private var margin: Double = 0.1
    private var unit: Int = 2500
    
    private var minValue: Double = 0
    private var maxValue: Double = 0
    private var range: Double = 0
    private var minGraphValue: Double = 0
    private var maxGraphValue: Double = 0
    
    init(data: GraphInput) {
        createHelperVariables(data: data)
        rawData = data
        axisXData = createAxisXData(data: data)
        axisYData = createAxisYData(data: data)
        graphData = createGraphData(data: data)
    }
    
    
    
    private func createAxisXData(data: GraphInput) -> AxisData {
        var xdata: AxisData = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let getMonthFormatter = DateFormatter()
        getMonthFormatter.dateFormat = "MMM"
        for i in 0..<data.count {
            let dateString = data[i].date
            let start = dateString.index(dateString.startIndex, offsetBy: 8)
            let end = dateString.index(dateString.startIndex, offsetBy: 9)
            if String(dateString[start...end]) == "01" {
                guard let date = dateFormatter.date(from: data[i].date) else { return [] }
                let monthString = getMonthFormatter.string(from: date)
                xdata.append((Double(i)/Double(data.count), monthString))
            }
        }
        return xdata
    }
    
    private func createAxisYData(data: GraphInput) -> AxisData {
        var ydata: AxisData = []
        
        func getRelativePostion(_ i: Double) -> Double {
            if i < minGraphValue || i > maxGraphValue {
            return -1
            }
            return (i - minGraphValue)/range
        }
        
        var i: Double = Double(Int(minGraphValue/Double(unit)) * unit)
        while i <= Double(Int(maxGraphValue/Double(unit)) * unit) {
            let position = getRelativePostion(i)
            if position > 0 && position < 1 {
                ydata.append((position, String(Int(i))))
            }
            i += Double(unit)
        }
        return ydata
    }
    
    private func createGraphData(data: GraphInput) -> GraphData {
        
        var graphData: GraphData = []
        
        func getRelativeYposition(value: Double) -> Double {
            let relativeYPosition = margin + (value - minValue)/(maxValue - minValue) * ( 1 - 2 * margin )
            return relativeYPosition
        }
        
        for (index, entry) in data.enumerated() {
            graphData.append((Double(index)/Double(data.count), getRelativeYposition(value: entry.value)))
        }
        
        return graphData
    }
    
    mutating private func createHelperVariables(data: GraphInput) {
        let dataSorted = data.sorted { (first, second) -> Bool in
            return first.value > second.value
        }
        minValue = dataSorted.last?.value ?? 0
        maxValue = dataSorted.first?.value ?? 0
        range = maxValue - minValue
        minGraphValue = minValue - range * margin
        maxGraphValue = maxValue + range * margin
    }
}


