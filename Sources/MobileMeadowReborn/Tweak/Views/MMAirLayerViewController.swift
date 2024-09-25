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
import MobileMeadowRebornC

class MMAirLayerViewController: UIViewController {
    
    //MARK: - Variables
    //Singelton
    static let shared = MMAirLayerViewController(withFrame: UIScreen.main.bounds)
    
    ///MMAirLayerViewController
    private let frame: CGRect
    private let birdsManager: SBBirdsManager = SBBirdsManager.shared
    private weak var timer: Timer?
    
    // MARK: - Initializers
    private init(withFrame frame: CGRect) {
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAllBirds), name: UIDevice.orientationDidChangeNotification, object: nil)
        setRandomTimer()
    }
    
    override var shouldAutorotate: Bool { return false }
    
    //MARK: - Functions
    @objc private func createBirdView() {
        guard let randomBirdName = birdsManager.birdImagesNames.randomElement() else { return }
        guard let isSpringBoardLocked = (UIApplication.shared as? SpringBoard)?.isLocked() else { return }
        
        setRandomTimer()
        
        if !isSpringBoardLocked {
            if tweakPrefs.birdsHiddenInLandscape && UIDevice.current.orientation.isLandscape { return }
            remLog(randomBirdName)
            birdsManager.createRandomWindowBird(withName: randomBirdName) { _ in
                remLog("removed bird")
            }
        }
    }
    
    private func setRandomTimer() {
        let duration: UInt = UInt.random(in: birdsManager.birdsSpawnRate.min...birdsManager.birdsSpawnRate.max)
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: CGFloat(duration).rounded(), target: self, selector: #selector(createBirdView), userInfo: nil, repeats: false)
    }
    
    func updateOrientation(for view: MMBirdView) {
        // Let birds change their direction for different orientations
        guard let position = view.position, !UIDevice.current.orientation.isFlat else { return }
        
        let rotationAngle: CGFloat
        let scaleX: CGFloat
        
        switch UIDevice.current.orientation {
        case .portrait:
            rotationAngle = 0
            scaleX = 1
            
        case .portraitUpsideDown:
            rotationAngle = .pi
            scaleX = -1
            
        case .landscapeLeft:
            if view.isBirdFlipped {
                rotationAngle = position.startY >= position.endY ? .pi / 2 : -.pi / 2
                scaleX = position.startY >= position.endY ? 1 : -1
            } else {
                rotationAngle = position.startY <= position.endY ? .pi / 2 : -.pi / 2
                scaleX = position.startY <= position.endY ? 1 : -1
            }
            
        case .landscapeRight:
            if !view.isBirdFlipped {
                rotationAngle = position.startY >= position.endY ? -.pi / 2 : .pi / 2
                scaleX = position.startY >= position.endY ? 1 : -1
            } else {
                rotationAngle = position.startY <= position.endY ? -.pi / 2 : .pi / 2
                scaleX = position.startY <= position.endY ? 1 : -1
            }
            
        default: return
        }
        
        view.transform = CGAffineTransform.identity
        view.transform = CGAffineTransform(rotationAngle: rotationAngle).concatenating(CGAffineTransform(scaleX: scaleX, y: 1))
    }
    
    //MARK: - Observers
    @objc private func updateAllBirds() {
        for subview in self.view.subviews {
            if subview.isKind(of: MMBirdView.self) {
                guard let birdView = subview as? MMBirdView else { return }
                updateOrientation(for: birdView)
            }
        }
    }
}
