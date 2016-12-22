//
//  ComplicationController.swift
//  raspberrysaucewatch Extension
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        //let myDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        //var data : Dictionary = myDelegate.myComplicationData[ComplicationCurrentEntry]!
        
        print("watch getCurrentTimelineEntry")
        
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        let textTemplate = CLKComplicationTemplateModularSmallSimpleText()
        
        let model = extensionDelegate.getModel()
        
        let text = (model != nil) ? TemperatureFormatter.asString(temperature: model!.temperature) : "??"
        
        textTemplate.textProvider = CLKSimpleTextProvider(text: text, shortText: text)
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: textTemplate)

        handler(entry)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        // TODO: implement placeholder template
        handler(nil)
    }
    
}
