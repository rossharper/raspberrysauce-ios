//
//  SetbackCell.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 27/04/2018.
//  Copyright © 2018 rossharper.net. All rights reserved.
//

import UIKit

class SetbackCell : UITableViewCell {
    @IBOutlet weak var modeIcon: UIImageView!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    func render(startTime: String) {
        startTimeLabel.text = startTime
        modeIcon.image = modeIcon.image?.withRenderingMode(.alwaysTemplate)
        modeIcon.tintColor = ProgrammeModeColor.setbackColor
    }
}
