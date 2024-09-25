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

class PreferenceCollection {
    
    //MARK: - Birds
    ///Not needed here, as this project is only for the plants in Applications
    
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
            let currentSize = PlantsSize.getSize()
            switch currentSize {
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
}
