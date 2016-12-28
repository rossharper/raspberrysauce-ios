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
        guard let model = extensionDelegate.getModel() else {
            handler(nil)
            return
        }
        
        let fullText = TemperatureFormatter.asString(model.temperature)
        let valueText = TemperatureFormatter.valueAsString(model.temperature)
        let unitText = TemperatureFormatter.unitAsString(model.temperature)
        
        var template : CLKComplicationTemplate
        
        switch(complication.family) {
        case .circularSmall:
            let textTemplate = CLKComplicationTemplateCircularSmallStackText()
            textTemplate.line1TextProvider = CLKSimpleTextProvider(text: valueText)
            textTemplate.line2TextProvider = CLKSimpleTextProvider(text: unitText)
            template = textTemplate
        case .modularSmall:
            let stacktemplate = CLKComplicationTemplateModularSmallStackImage()
            stacktemplate.line1ImageProvider = CLKImageProvider(onePieceImage: imageForProgrammeMode(model.programme))
            stacktemplate.line2TextProvider = CLKSimpleTextProvider(text: fullText)
            template = stacktemplate
        case .modularLarge:
            let textTemplate = CLKComplicationTemplateModularLargeTallBody()
            textTemplate.headerTextProvider = CLKSimpleTextProvider(text: ProgrammeModeFormatter.asString(programme: model.programme))
            textTemplate.bodyTextProvider = CLKSimpleTextProvider(text: fullText)
            template = textTemplate
        case .utilitarianSmall:
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: fullText)
            template = textTemplate
        case .utilitarianSmallFlat:
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: fullText)
            template = textTemplate
        case .utilitarianLarge:
            let textTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: fullText)
            template = textTemplate
        case .extraLarge:
            let textTemplate = CLKComplicationTemplateExtraLargeSimpleText()
            textTemplate.textProvider = CLKSimpleTextProvider(text: fullText)
            template = textTemplate
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)

        handler(entry)
    }
    
    private func imageForProgrammeMode(_ programme: Programme) -> UIImage {
        switch(programme.heatingEnabled, programme.comfortLevelEnabled) {
        case (false, _):
            return #imageLiteral(resourceName: "OffModeMenuIcon").withRenderingMode(.alwaysTemplate)
        case (true, true):
            return #imageLiteral(resourceName: "ComfortModeMenuIcon").withRenderingMode(.alwaysTemplate)
        case (true, false):
            return #imageLiteral(resourceName: "SetbackModeMenuIcon").withRenderingMode(.alwaysTemplate)
        }
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        // TODO: implement placeholder template
        handler(nil)
    }
    
}
