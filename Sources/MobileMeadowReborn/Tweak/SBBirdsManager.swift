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

class SBBirdsManager {
    
    //MARK: - Variables
    ///Singelton
    static let shared = SBBirdsManager()
    private lazy var airLayerViewController: MMAirLayerViewController = MMAirLayerViewController.shared
    private lazy var meadowDockGroundView: MMGroundContainerView = MMGroundContainerView.shared
    
    let birdImagesNames: [String] = ["greenbird", "redbird", "ufo"]
    let birdDeliveryName: String = "deliverybird"
    
    ///Preferences
    let birdsSpawnRate: (min: UInt, max: UInt) = PreferenceCollection.BirdsSpawnRate.setRate()
    let birdsAnimationDuration: (min: CGFloat, max: CGFloat) = PreferenceCollection.BirdsAnimationDuration.setDuration()
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Functions
    func createRandomWindowBird(withName name: String, completion: @escaping (Bool) -> Void) {
        let birdView = MMBirdView(withBirdName: name)
        airLayerViewController.view.addSubview(birdView)
        
        BirdAnimation.animateBird(view: birdView, action: .flyAcross, birdsDuration: birdsAnimationDuration) { [weak self] finished in
            guard let strongSelf = self else { return }
            strongSelf.removeBirdFromSuperview(birdView)
            completion(finished)
        }
    }
    
    func handleLandingDeliveryBird() {
        for subview in airLayerViewController.view.subviews {
            if subview.isKind(of: MMBirdView.self) {
                guard let birdView = subview as? MMBirdView, !birdView.isBirdDelivery else { return }
            }
        }
        
        createRandomWindowBird(withName: birdDeliveryName) { [weak self] finished in
            guard let strongSelf = self else { return }
            if finished {
                if !strongSelf.meadowDockGroundView.mailBoxView.isDeliveryBirdLanded {
                    guard let meadowGroundSuperview = strongSelf.meadowDockGroundView.superview else { return }
                    for subview in meadowGroundSuperview.subviews { if subview.isKind(of: MMBirdView.self) { return } }
                    
                    let landingBirdView = MMBirdView(withBirdName: strongSelf.birdDeliveryName)
                    meadowGroundSuperview.addSubview(landingBirdView)
                    BirdAnimation.animateBird(view: landingBirdView, action: .land, birdsDuration: nil) { [weak self] finished in
                        guard let strongSelf = self else { return }
                        if finished {
                            strongSelf.meadowDockGroundView.mailBoxView.handleState(.full)
                            strongSelf.removeBirdFromSuperview(landingBirdView)
                            remLog("removed landing deliverybird")
                        }
                    }
                }
            }
        }
    }
    
    func handleFlyingAwayDeliveryBird() {
        guard let superview = meadowDockGroundView.superview, meadowDockGroundView.mailBoxView.isDeliveryBirdLanded else { return }
        
        let flyingAwayBird: MMBirdView = MMBirdView.init(withBirdName: birdDeliveryName)
        superview.addSubview(flyingAwayBird)
        
        BirdAnimation.animateBird(view: flyingAwayBird, action: .flyAway, birdsDuration: birdsAnimationDuration) { [weak self] finished in
            guard let strongSelf = self else { return }
            if finished {
                strongSelf.removeBirdFromSuperview(flyingAwayBird)
                remLog("removed flyingaway deliverybird")
            }
        }
    }
    
    private func removeBirdFromSuperview(_ view: MMBirdView) {
        view.timer?.invalidate()
        view.removeFromSuperview()
    }
}
