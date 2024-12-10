import Foundation

let plistPath: String = FileManager.default.fileExists(atPath: "/var/jb/")
                        ? "/var/jb/var/mobile/Library/Preferences/"
                        : "/var/mobile/Library/Preferences/"

var prefsAssetsPath: String {
    var path: String = "/var/jb/Library/PreferenceBundles/MobileMeadowRebornPrefs.bundle/"
    if !FileManager.default.fileExists(atPath: path) {
        path = "/Library/PreferenceBundles/MobileMeadowRebornPrefs.bundle/"
    }
    
    return path
}
