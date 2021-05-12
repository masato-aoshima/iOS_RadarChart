//
//  GroupListCell.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/10.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class GroupListCell: UITableViewCell {
    
    @IBOutlet weak var radarChart: SampleChartInTableCell!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var subTitleView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
