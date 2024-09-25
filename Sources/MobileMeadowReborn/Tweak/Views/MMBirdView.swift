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

class MMBirdView: UIView {
    
    //MARK: - Structs
    struct ViewPosition {
        let startX: CGFloat
        let startY: CGFloat
        let endX: CGFloat
        let endY: CGFloat
    }
    
    //MARK: - Propertys
    private let birdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Variables
    private let birdNamesArray: [[String]] = [
        ["deliverybird_0", "deliverybird_1", "deliverybird_2"],
        ["greenbird_0", "greenbird_1", "greenbird_2"],
        ["redbird_0", "redbird_1", "redbird_2"],
        ["ufo_0", "ufo_1", "ufo_2"]
    ]
    
    private let duration: CGFloat = 0.1
    private var currentIndex = 0
    private var isAnimationForward: Bool = true
    var birdImages: [UIImage] = []
    var isBirdDelivery: Bool = false
    var isBirdFlipped: Bool = (arc4random_uniform(2) != 0)
    var position: MMBirdView.ViewPosition?
    weak var timer: Timer?
    
    //MARK: - Initializer
    init(withBirdName name: String) {
        super.init(frame: .zero)
        
        getBirdImages(withPrefix: name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func getBirdImages(withPrefix prefix: String) {
        isBirdDelivery = prefix == SBBirdsManager.shared.birdDeliveryName ? true : false
        
        for birdNames in birdNamesArray {
            if birdNames.contains(where: { $0.contains(prefix) }) {
                for birdName in birdNames {
                    guard let image = MMAssets.imageNamed(birdName) else {
                        remLog("The images with name: \(birdName) can't be found on the device!")
                        return
                    }
                    if isBirdFlipped && !isBirdDelivery {
                        let flippedImage = image.withHorizontallyFlippedOrientation()
                        birdImages.append(flippedImage)
                    } else { birdImages.append(image) }
                }
            }
        }
        
        if birdImages.count <= 0 {
            remLog("The images with prefix: \(prefix) can't be found!")
        } else if birdImages.count <= 2 {
            remLog("The images with prefix: \(prefix) doesn't have atleast 3 frames or more!")
        } else {
            setupBirdView(withImages: birdImages)
        }
    }
    
    private func setupBirdView(withImages images: [UIImage]) {
        let imageWidth: CGFloat = images[0].size.width
        let imageHeight: CGFloat = images[0].size.height
        
        self.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        self.addSubview(birdImageView)
        
        NSLayoutConstraint.activate([
            birdImageView.topAnchor.constraint(equalTo: self.topAnchor),
            birdImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            birdImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            birdImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(loopBirdImages), userInfo: nil, repeats: true)
    }
    
    @objc private func loopBirdImages() {
        if isAnimationForward {
            currentIndex += 1
            if currentIndex >= birdImages.count - 1 {
                isAnimationForward = false
            }
        } else {
            currentIndex -= 1
            if currentIndex <= 0 {
                isAnimationForward = true
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.birdImageView.image = strongSelf.birdImages[strongSelf.currentIndex]
        }, completion: nil)
    }
}
