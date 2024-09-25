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

struct BirdAnimation {
    
    //MARK: - Emums
    enum BirdAction {
        case flyAcross
        case land
        case flyAway
    }

    //MARK: - Initializer
    private init() {}
    
    //MARK: - Functions
    static func animateBird(view: MMBirdView, action: BirdAction, birdsDuration: (min: CGFloat, max: CGFloat)?, completion: @escaping (Bool) -> Void) {
        let airLayerFrame = MMAirLayerViewController.shared.view.frame
        let meadowMailboxFrame = MMGroundContainerView.shared.mailBoxView.frame
        let isLandscape = UIDevice.current.orientation.isLandscape
        let deviceType = UIDevice.getDeviceType()
        
        let startXPos: CGFloat
        let startYPos: CGFloat
        let endXPos: CGFloat
        let endYPos: CGFloat
        let delay: CGFloat
        let duration: CGFloat
        
        if let birdsDuration = birdsDuration {
            duration = CGFloat.random(in: birdsDuration.min...birdsDuration.max).rounded()
            delay = 0.2
        } else {
            duration = deviceType == .iphone ? 3.0 : 6.0
            delay = duration / 2
        }
        
        switch action {
        case .flyAcross:
            if view.isBirdDelivery {
                let startAndEndYPos: CGFloat = airLayerFrame.height * 0.15
                startXPos = -view.frame.width
                startYPos = startAndEndYPos
                endXPos = airLayerFrame.width
                endYPos = startAndEndYPos
            } else {
                startYPos = CGFloat.random(in: 0...airLayerFrame.height)
                endYPos = CGFloat.random(in: 0...airLayerFrame.height)
                
                if view.isBirdFlipped {
                    startXPos = airLayerFrame.width
                    endXPos = -view.frame.width
                } else {
                    startXPos = -view.frame.width
                    endXPos = airLayerFrame.width
                }
            }
            view.position = MMBirdView.ViewPosition(startX: startXPos, startY: startYPos, endX: endXPos, endY: endYPos)
            MMAirLayerViewController.shared.updateOrientation(for: view)
            
        case .flyAway:
            // Animation for the delivery bird on top of the mailbox
            startXPos = meadowMailboxFrame.origin.x
            startYPos = ((meadowMailboxFrame.origin.y - meadowMailboxFrame.height) + (meadowMailboxFrame.height / 2)) + 10
            endXPos = !isLandscape ? -((airLayerFrame.width - view.frame.width) / 2) : -((airLayerFrame.height - view.frame.width) / 2)
            endYPos = !isLandscape ? -CGFloat.random(in: 0...airLayerFrame.height) : -CGFloat.random(in: 0...airLayerFrame.width)
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        case .land:
            // Animation for the delivery bird on top of the mailbox
            startXPos = !isLandscape ? airLayerFrame.width : airLayerFrame.height
            startYPos = !isLandscape ? -(airLayerFrame.height * 0.25) : (deviceType == .iphone ? -(airLayerFrame.width * 0.75) : -(airLayerFrame.width * 0.50))
            endXPos = meadowMailboxFrame.origin.x
            endYPos = ((meadowMailboxFrame.origin.y - meadowMailboxFrame.height) - (meadowMailboxFrame.height / 2)) + 5
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        view.frame.origin = CGPoint(x: startXPos, y: startYPos)
        animation(view: view, timing: (duration: duration, delay: delay), position: (endX: endXPos, endY: endYPos)) { finished in
            completion(finished)
        }
    }
    
    private static func animation(view: MMBirdView, timing: (duration: CGFloat, delay: CGFloat), position: (endX: CGFloat, endY: CGFloat), completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: timing.duration, delay: timing.delay, options: .curveLinear) {
            view.frame.origin = CGPoint(x: position.endX, y: position.endY)
        } completion: { finished in
            completion(finished)
        }
    }
}

