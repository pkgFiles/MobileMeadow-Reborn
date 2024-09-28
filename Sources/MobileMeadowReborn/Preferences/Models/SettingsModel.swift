import UIKit

struct SettingsModel: DictionaryConvertor, Codable {
    // General
    var isTweakEnabled: Bool = false
    
    // Birds
    var birdsEnabled: Bool = true
    var birdsSpawnRate: Int = 1
    var birdsAnimationDuration: Int = 1
    var birdsHiddenInLandscape: Bool = false
    var birdsHiddenInApplications: Bool = false
    
    // Plants
    var plantsEnabled: Bool = true
    var plantsSize: Int = 1
    var plantsAnimationsEnabled: Bool = true
    var plantsAnimationStyle: Int = 1
    var plantsHiddenInApps: Bool = false
    
    // Miscellanous
    ///MailBox
    var mailBoxEnabled: Bool = true
    var iconType: Int = 0
}
