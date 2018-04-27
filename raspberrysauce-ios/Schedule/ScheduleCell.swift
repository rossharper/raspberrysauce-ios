//
//  ScheduleCell.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 27/04/2018.
//  Copyright © 2018 rossharper.net. All rights reserved.
//

import UIKit

class ScheduleCell : UITableViewCell {

    @IBOutlet weak var modeIcon: UIImageView!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    func render(period: ProgrammePeriod) {
        startTimeLabel.text = period.startTime
        modeIcon.image = imageForPeriod(period).withRenderingMode(.alwaysTemplate)
        // TODO: get the color from a factory or something instead of magic statics?
        modeIcon.tintColor = colorForPeriod(period)
    }
    
    // TODO: make me a factory
    func imageForPeriod(_ period: ProgrammePeriod) -> UIImage {
        if (period.isComfort) {
            return #imageLiteral(resourceName: "ComfortModeIcon")
        } else {
            return #imageLiteral(resourceName: "SetbackModeIcon")
        }
    }
    
    func colorForPeriod(_ period: ProgrammePeriod) -> UIColor {
        if (period.isComfort) {
            return ProgrammeModeColor.comfortColor
        } else {
            return ProgrammeModeColor.setbackColor
        }
    }
}
