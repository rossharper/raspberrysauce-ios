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
        
        var template : CLKComplicationTemplate
        
        switch(complication.family) {
        case .circularSmall:
            let stacktemplate = CLKComplicationTemplateCircularSmallStackImage()
            stacktemplate.line1ImageProvider = getModSmallImageProvider(model.programme)
            let textProvider = CLKSimpleTextProvider(text: fullText)
            stacktemplate.line2TextProvider = textProvider
            template = stacktemplate
        case .modularSmall:
            let stacktemplate = CLKComplicationTemplateModularSmallStackImage()
            stacktemplate.line1ImageProvider = getModSmallImageProvider(model.programme)
            let textProvider = CLKSimpleTextProvider(text: fullText)
            stacktemplate.line2TextProvider = textProvider
            template = stacktemplate
        case .modularLarge:
            let textTemplate = CLKComplicationTemplateModularLargeTallBody()
            textTemplate.headerTextProvider = CLKSimpleTextProvider(text: ProgrammeModeFormatter.asStringWithEmoji(model.programme))
            textTemplate.bodyTextProvider = CLKSimpleTextProvider(text: fullText)
            template = textTemplate
        case .utilitarianSmall:
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: "\(ProgrammeModeFormatter.asEmoji(model.programme)) \(fullText)")
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
            let stacktemplate = CLKComplicationTemplateExtraLargeStackImage()
            // TODO: larger icon required here
            stacktemplate.line1ImageProvider = getModSmallImageProvider(model.programme)
            let textProvider = CLKSimpleTextProvider(text: fullText)
            stacktemplate.line2TextProvider = textProvider
            template = stacktemplate
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)

        handler(entry)
    }
    
    private func getModSmallImageProvider(_ programme: Programme) -> CLKImageProvider {
        var imageProvider : CLKImageProvider
        
        switch(programme.heatingEnabled, programme.comfortLevelEnabled) {
        case (false, _):
            imageProvider =  CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "ModSmallOffIcon"))
        case (true, true):
            imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "ModSmallComfortIcon"))
        case (true, false):
            imageProvider =  CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "ModSmallSetbackIcon"))
        }
        
        imageProvider.tintColor = ProgrammeModeColor.colorForMode(programme)
        return imageProvider
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        // TODO: implement placeholder template
        handler(nil)
    }
    
}
