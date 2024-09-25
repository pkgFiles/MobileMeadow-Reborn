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

import UIKit

struct PlantAnimation {
    init(animationStyle: PreferenceCollection.PlantsAnimationStyle, for imageView: UIImageView?) {
        var animation: ((Bool) -> Void)?
        
        switch animationStyle {
        case .defaultStyle:
            var isLeftToRight: Bool = (arc4random_uniform(2) != 0)
            
            animation = { [weak imageView] finished in
                guard let weakImageView = imageView else { return }
                isLeftToRight.toggle()
                if (finished) {
                    UIView.animate(withDuration: 1.5 + CGFloat(arc4random_uniform(400) / 100), delay: 0.0, options: [.curveEaseInOut], animations: {
                        var transform: CGAffineTransform = CGAffineTransform.identity
                        transform = CGAffineTransformTranslate(transform, 0.0, weakImageView.image!.size.height)
                        transform = CGAffineTransformRotate(transform, (isLeftToRight ? -20.0 : 20.0) * .pi / 180)
                        transform = CGAffineTransformTranslate(transform, 0.0, -weakImageView.image!.size.height)
                        weakImageView.transform = transform
                    }, completion: animation)
                }
            }
            
        case .windFromLeftStyle, .windFromRightStyle:
            var isCentered: Bool = (arc4random_uniform(2) != 0)
            
            animation = { [weak imageView] finished in
                guard let weakImageView = imageView else { return }
                let angle: CGFloat = animationStyle == .windFromLeftStyle ? (isCentered ? 10.0 : 25.0) : (isCentered ? -10.0 : -25.0)
                isCentered.toggle()
                if (finished) {
                    UIView.animate(withDuration: 1.5 + CGFloat(arc4random_uniform(200) / 100), delay: 0.0, options: [.curveEaseInOut], animations: {
                        var transform: CGAffineTransform = CGAffineTransform.identity
                        transform = CGAffineTransformTranslate(transform, 0.0, weakImageView.image!.size.height)
                        transform = CGAffineTransformRotate(transform, angle * .pi / 180)
                        transform = CGAffineTransformTranslate(transform, 0.0, -weakImageView.image!.size.height)
                        weakImageView.transform = transform
                    }, completion: animation)
                }
            }
        }
        
        tweakPrefs.plantsAnimationsEnabled ? animation?(true) : animation?(false)
    }
}
