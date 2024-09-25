import Foundation

var prefsAssetsPath: String {
    var path: String = "/var/jb/Library/PreferenceBundles/MobileMeadowRebornPrefs.bundle/"
    if !FileManager.default.fileExists(atPath: path) {
        path = "/Library/PreferenceBundles/MobileMeadowRebornPrefs.bundle/"
    }
    
    return path
}
