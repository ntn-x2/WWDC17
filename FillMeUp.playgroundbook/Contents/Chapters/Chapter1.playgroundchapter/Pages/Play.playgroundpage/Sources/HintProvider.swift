import PlaygroundSupport
import CoreImage

//Shows the correct hint based on the filter chosen by the user
public class HintProvider {
    public static func showHint(forFilterType filterType: ImageFilterType) {
        
        var message = "You can"
        
        let filterKeys = filterType.availableKeys
        
        for key in filterKeys {
            switch key {
            case kCIInputCenterKey:
                message += " *pan with one finger*,"
            case kCIInputRadiusKey:
                message += " *pinch in-out*,"
            case kCIInputAngleKey:
                message += " *rotate*,"
            case kCIInputScaleKey:
                message += " *pan with two fingers*,"
            default:
                message += " *use no gestures*,"
            }
        }
        
        message = message.substring(to: message.index(before: message.endIndex)) + " to modify your filter! If you cannot find where the filter is, just tap anywhere on the image and the helper will... help you."
        
        PlaygroundPage.current.assessmentStatus = .fail(hints: [message], solution: nil)
    }
}
