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
    
    let noDataMessage = "?"
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        //let myDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        //var data : Dictionary = myDelegate.myComplicationData[ComplicationCurrentEntry]!
        
        print("watch getCurrentTimelineEntry")

        var template : CLKComplicationTemplate
        
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        let model = extensionDelegate.getModel()
        
        switch(complication.family) {
        case .circularSmall:
            template = templateForCircularSmall(with: model)
        case .modularSmall:
            template = templateForModularSmall(with: model)
        case .modularLarge:
            template = templateForModularLarge(with: model)
        case .utilitarianSmall:
            template = templateForUtilitarianSmall(with: model)
        case .utilitarianSmallFlat:
            template = templateForUtilitarianSmallFlat(with: model)
        case .utilitarianLarge:
            template = templateForUtiliratianLarge(with: model)
        case .extraLarge:
            template = templateForExtraLarge(with: model)
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)

        handler(entry)
    }
    
    private func templateForCircularSmall(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let stacktemplate = CLKComplicationTemplateCircularSmallStackImage()
        stacktemplate.line1ImageProvider = getModSmallImageProvider(model.programme)
        let textProvider = CLKSimpleTextProvider(text: TemperatureFormatter.asString(model.temperature))
        stacktemplate.line2TextProvider = textProvider
        return stacktemplate
    }
    
    private func templateForModularSmall(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let stacktemplate = CLKComplicationTemplateModularSmallStackImage()
        stacktemplate.line1ImageProvider = getModSmallImageProvider(model.programme)
        let textProvider = CLKSimpleTextProvider(text: TemperatureFormatter.asString(model.temperature))
        stacktemplate.line2TextProvider = textProvider
        return stacktemplate
    }
    
    private func templateForModularLarge(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateModularLargeTallBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let textTemplate = CLKComplicationTemplateModularLargeTallBody()
        textTemplate.headerTextProvider = CLKSimpleTextProvider(text: ProgrammeModeFormatter.asStringWithEmoji(model.programme))
        textTemplate.bodyTextProvider = CLKSimpleTextProvider(text: TemperatureFormatter.asString(model.temperature))
        return textTemplate
    }
    
    private func templateForUtilitarianSmall(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
        textTemplate.textProvider = CLKSimpleTextProvider(text: "\(ProgrammeModeFormatter.asEmoji(model.programme)) \(TemperatureFormatter.asString(model.temperature))")
        return textTemplate
    }
    
    private func templateForUtilitarianSmallFlat(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
        textTemplate.textProvider = CLKSimpleTextProvider(text: TemperatureFormatter.asString(model.temperature))
        return textTemplate
    }
    
    private func templateForUtiliratianLarge(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let textTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
        textTemplate.textProvider = CLKSimpleTextProvider(text: TemperatureFormatter.asString(model.temperature))
        return textTemplate
    }
    
    private func templateForExtraLarge(with model : HomeViewData?) -> CLKComplicationTemplate {
        guard let model = model else {
            let template = CLKComplicationTemplateExtraLargeSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: noDataMessage)
            return template
        }
        
        let stacktemplate = CLKComplicationTemplateExtraLargeStackImage()
        // TODO: larger icon required here
        stacktemplate.line1ImageProvider = getModSmallImageProvider(model.programme)
        let textProvider = CLKSimpleTextProvider(text: TemperatureFormatter.asString(model.temperature))
        stacktemplate.line2TextProvider = textProvider
        return stacktemplate
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
