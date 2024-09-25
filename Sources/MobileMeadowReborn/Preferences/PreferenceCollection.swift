/*
 
 MIT License

 Copyright (c) 2024 ★ Install Package Files

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import Foundation
import UIKit

class PreferenceCollection {
    
    //MARK: - Birds
    enum BirdsSpawnRate {
        case defaultRate, rarelyRate, frequentlyRate
        
        private static func getRate() -> BirdsSpawnRate {
            switch tweakPrefs.birdsSpawnRate {
            case 0: return .rarelyRate
            case 1: return .defaultRate
            case 2: return .frequentlyRate
            default: break
            }
            
            return .defaultRate
        }
        
        static func setRate() -> (min: UInt, max: UInt) {
            switch BirdsSpawnRate.getRate() {
            case .rarelyRate: return (min: 1, max: 60)
            case .defaultRate: return (min: 1, max: 30)
            case .frequentlyRate: return (min: 1, max: 15)
            }
        }
    }
    
    enum BirdsAnimationDuration {
        case defaultDuration, slowerDuration, fasterDuration
        
        private static func getDuration() -> BirdsAnimationDuration {
            switch tweakPrefs.birdsAnimationDuration {
            case 0: return .slowerDuration
            case 1: return .defaultDuration
            case 2: return .fasterDuration
            default: break
            }
            
            return .defaultDuration
        }
        
        static func setDuration() -> (min: CGFloat, max: CGFloat) {
            let deviceType = UIDevice.getDeviceType()
            var duration: (min: CGFloat, max: CGFloat)
            
            switch BirdsAnimationDuration.getDuration() {
            case .slowerDuration: duration = (min: 6.0, max: 8.0)
            case .defaultDuration: duration = (min: 3.0, max: 6.0)
            case .fasterDuration: duration = (min: 2.0, max: 4.0)
            }
            
            return deviceType == .ipad ? (min: duration.min * 2, max: duration.max * 2) : (min: duration.min, max: duration.max)
        }
    }
    
    //MARK: - Plants
    enum PlantsSize {
        case high, medium, low
        
        private static func getSize() -> PlantsSize {
            switch tweakPrefs.plantsSize {
            case 0: return .low
            case 1: return .medium
            case 2: return .high
            default: break
            }
            
            return .medium
        }
        
        static func setSize() -> Int {
            switch PlantsSize.getSize() {
            case .high: return 10
            case .medium: return 20
            case .low: return 30
            }
        }
    }
    
    enum PlantsAnimationStyle {
        case defaultStyle, windFromLeftStyle, windFromRightStyle
        
        static func getStyle() -> PlantsAnimationStyle {
            switch tweakPrefs.plantsAnimationStyle {
            case 0: return .windFromLeftStyle
            case 1: return .defaultStyle
            case 2: return .windFromRightStyle
            default: break
            }
            
            return .defaultStyle
        }
    }
    
    //MARK: - Miscellanous
    ///MailBox
    enum MailBoxIconType {
        case defaultIcon, appIcon
        
        static func getIconType() -> MailBoxIconType {
            switch tweakPrefs.iconType {
            case 0: return .defaultIcon
            case 1: return .appIcon
            default: break
            }
            
            return .defaultIcon
        }
    }
}
