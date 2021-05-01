//
//  GroupCreatePresenter.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/22.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

class GroupCreatePresenter:GroupCreatePresenterInput{
    
    private weak var view:GroupCreaterPresenterOutput!
    var chartData: RadarChartData = MyChartUtil.getSampleChartData(color: UIColor.systemTeal, numberOfItems: 8)
    private var id : String? = nil
    private var createdAt : Date? = nil
    var title = ""
    var sliderLabel = ["3","4","5","6","7","8"]
    var selectedColor: UIColor = UIColor.systemTeal
    var numberOfItems: Int = 5
    var axisMaximum: Int = 100
    var chartLabels: [String] = ["項目1","項目2","項目3","項目4","項目5","項目6","項目7","項目8","項目9"]
    
    init(view:GroupCreaterPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(passedData:ChartGroup?) {
        // 最初に最大数のEntryで初期化しないと、Entryの数を大きくしたときクラッシュするため
        chartData = MyChartUtil.getSampleChartData(color: selectedColor, numberOfItems: 8)
        view.setChartDataSource()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if(passedData != nil){
                self.id = passedData!.id
                self.createdAt = passedData!.createdAt
                self.title = passedData!.title
                self.selectedColor = ColorUtil.convertStringToColor(colorString: passedData!.color)
                self.numberOfItems = Int(passedData!.labels.count)
                self.axisMaximum = passedData!.maximum
                for i in 0..<passedData!.labels.count{
                    self.chartLabels[i] = Array(passedData!.labels)[i]
                }
                self.view.reflectThePassedData()
            }
            self.onChangeChartData()
        }
    }
    
    func didSelectColor(color: UIColor) {
        selectedColor = color
        view.updateColor(color: selectedColor)
        onChangeChartData()
    }
    
    func didSliderValueChanged(index: Int) {
        numberOfItems = index + 3
        view.updateNumberOfItems(num: numberOfItems,chartLabels: chartLabels)
        onChangeChartData()
    }
    
    private func onChangeChartData(){
        chartData.removeDataSetByIndex(0)
        chartData.addDataSet(MyChartUtil.getSampleChartDataSet(color: selectedColor, numberOfItems: numberOfItems))
        view.notifyChartDataChanged()
    }
    
    func titleTextFieldDidEndEditing(text: String) {
        title = text
    }
    
    func labelTextFieldDidEndEditing(index: Int, text: String) {
        chartLabels[index] = text
        view.onUpdateChartLabel()
    }
    
    func axisMaximumTextFieldDidEndEditing(text: String) {
        axisMaximum = Int(text) ?? 100
    }
    
    func onTapSaveButton() {
        // 項目のバリデーション
        let errorMessage = validateData()
        if(errorMessage != ""){
            view.showValidateDialog(text: errorMessage)
            return
        }
        
        // データベースへの書き込み
        let group = getChartGroupObject()
        DBProvider.sharedInstance.addGroup(object: group)
        
        // 画面を閉じる
        view.completeWritingToDatabase()
    }
    
    // 問題なければ空文字を、データに不正があればエラーメッセージを返す
    private func validateData() -> String{
        if(title == ""){
            return "タイトルが未入力です"
        }
        if(axisMaximum == 0){
            return "グラフの最大値が不正です"
        }
        for i in 0..<chartLabels.count{
            if(chartLabels[i] == ""){
                return "項目名が空です"
            }
        }
        return ""
    }
    
    private func getChartGroupObject() -> ChartGroup{
        var group:ChartGroup? = nil
        if(id == nil){
            group = ChartGroup(value: ["title":title,"color":ColorUtil.convertColorToString(color: selectedColor),"maximum":axisMaximum,"labels":Array(chartLabels.prefix(numberOfItems))])
        }else{
            group = ChartGroup(value: ["id":id!,"title":title,"color":ColorUtil.convertColorToString(color: selectedColor),"maximum":axisMaximum,"labels":Array(chartLabels.prefix(numberOfItems)),"createdAt":createdAt!])
        }
        return group!
    }
}

// GroupCreatePresenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupCreatePresenterInput {
    var title:String{get}
    var chartData:RadarChartData{get}
    var chartLabels:[String]{get}
    var sliderLabel:[String]{get}
    var selectedColor:UIColor{get set}
    var numberOfItems:Int{get set}
    var axisMaximum:Int{get set}
    func viewDidLoad(passedData:ChartGroup?)
    func didSelectColor(color:UIColor)
    func didSliderValueChanged(index:Int)
    func titleTextFieldDidEndEditing(text:String)
    func labelTextFieldDidEndEditing(index:Int,text:String)
    func axisMaximumTextFieldDidEndEditing(text:String)
    func onTapSaveButton()
}

// GroupCreateViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupCreaterPresenterOutput:AnyObject {
    func reflectThePassedData()
    func updateNumberOfItems(num:Int,chartLabels:[String])
    func updateColor(color:UIColor)
    func setChartDataSource()
    func notifyChartDataChanged()
    func onUpdateChartLabel()
    func showValidateDialog(text:String)
    func completeWritingToDatabase()
}
