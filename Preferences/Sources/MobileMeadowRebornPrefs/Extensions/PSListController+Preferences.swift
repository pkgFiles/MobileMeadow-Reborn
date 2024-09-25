import Preferences
import MobileMeadowRebornPrefsC

extension PSListController {
        
    private var plistPath: String {
        let fileManager = FileManager()
        var plistPath: String = "/var/mobile/Library/Preferences/"
        
        if !fileManager.fileExists(atPath: "/var/LIY/") && fileManager.fileExists(atPath: "/var/jb/") {
            plistPath = "/var/jb/var/mobile/Library/Preferences/"
        }
        
        return plistPath
    }
    
    open override func readPreferenceValue(_ specifier: PSSpecifier!) -> Any! {
        guard let defaultPath = specifier.properties["defaults"] as? String else {
            return super.readPreferenceValue(specifier)
        }

        let path = "\(plistPath)\(defaultPath).plist"
        let settings = NSDictionary(contentsOfFile: path)

        return settings?[specifier.property(forKey: "key") as Any] ?? specifier.property(forKey: "default")
    }
    
    open override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        let path = "\(plistPath)\(specifier.properties["defaults"] as! String).plist"
        let prefs = NSMutableDictionary(contentsOfFile:path) ?? NSMutableDictionary()
        
        prefs.setValue(value, forKey: specifier.property(forKey: "key") as! String)
        prefs.write(toFile: path, atomically: true)
    }
}
