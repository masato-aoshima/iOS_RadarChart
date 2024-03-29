
//
//  SampleChartInCollectionCell.swift
//  RadarChart
//
//  Created by aoshima on 2021/05/12.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class ChartForCollectionView:RadarChartView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rotationEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        
        let xAxis = self.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9.5,weight: .light)
        xAxis.valueFormatter = RowXAxisFormatter()
        
        let yAxis = self.yAxis
        //分割数
        yAxis.setLabelCount(6, force: true)
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 100
        yAxis.axisRange = 100
        yAxis.spaceMax = 0
        yAxis.spaceMin = 0
    }
    
    func setData(group:ChartGroup,chartObject:MyChartObject,labelSize:LabelSizeType){
        fixedLabelSize = labelSize.rawValue
        
        var temporalyLabels = Array(group.labels)
        temporalyLabels.append("")
        
        (self.xAxis.valueFormatter as! RowXAxisFormatter).setLabel(labels: temporalyLabels)
        self.yAxis.axisMaximum = group.maximum
        self.yAxis.axisRange = group.maximum
        
        let chartData = MyChartUtil.getChartDataBasedOnInputValues(color: chartObject.color.toUIColor(), values: Array(chartObject.values))
        self.data = chartData
        
        self.notifyDataSetChanged()
    }
}
