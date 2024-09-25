import UIKit

struct SettingsModel: DictionaryConvertor, Codable {
    // General
    var isTweakEnabled: Bool = false
    
    // Birds
    ///Not needed here, as this project is only for the plants in Applications
    
    // Plants
    var plantsEnabled: Bool = true
    var plantsSize: Int = 1
    var plantsAnimationsEnabled: Bool = true
    var plantsAnimationStyle: Int = 1
    var plantsHiddenInApps: Bool = false
    
    // Miscellanous
    ///Not needed here, as this project is only for the plants in Applications
}
