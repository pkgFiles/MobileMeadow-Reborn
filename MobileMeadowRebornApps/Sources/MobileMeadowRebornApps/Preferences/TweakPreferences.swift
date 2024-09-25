import Foundation

class TweakPreferences {
    static let preferences = TweakPreferences()
    
    func loadPreferences() -> SettingsModel {
        let fileManager = FileManager()
        let plistIdentifier: String = "com.pkgfiles.mobilemeadowrebornprefs.plist"
        var plistPath: String = "/var/mobile/Library/Preferences/" + plistIdentifier
        
        if !fileManager.fileExists(atPath: "/var/LIY/") && fileManager.fileExists(atPath: "/var/jb/") {
            plistPath = "/var/jb/var/mobile/Library/Preferences/" + plistIdentifier
        }
        
        if let data = fileManager.contents(atPath: plistPath) {
            remLog(Bundle.main.bundleIdentifier ?? "No bundleIdentifier found")
            do {
                let settings = try PropertyListDecoder().decode(SettingsModel.self, from: data)
                return settings
            } catch let error as NSError {
                remLog(error.localizedDescription)
                return loadPreferences()
            }
        } else { remLog("No preference data found!") }
        return SettingsModel()
    }
}
