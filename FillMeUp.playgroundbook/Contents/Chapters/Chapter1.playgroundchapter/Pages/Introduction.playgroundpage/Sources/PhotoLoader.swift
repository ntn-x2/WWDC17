import UIKit

public class PhotoLoader {
    
    private static let photosCount = 19
    
    //Returns the collection of all the photos representing modified faces present in the Resources folder of the Page
    public static let photosResources: [UIImage] = {
        return (1...PhotoLoader.photosCount).flatMap({ UIImage(named: "face\($0).PNG") })
    }()
}
