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

class MMGroundContainerView: UIView {
    
    //MARK: - Propertys
    lazy var mailBoxView: MMMailBoxView = {
        let view = MMMailBoxView()
        view.isDeliveryBirdLanded ? view.handleState(.full) : view.handleState(.empty)
        return view
    }()
    
    //MARK: - Variables
    //Singelton
    static let shared = MMGroundContainerView()
    
    ///MMGroundContainerView
    private var offset: CGFloat = 0.0
    private var lastUpdateX: CGFloat = 0.0
    private var imageViews: NSMutableArray = []
    private var animator: PlantAnimation? = PlantAnimation(animationStyle: .defaultStyle, for: .none)
    
    private lazy var isSpringBoard: Bool = {
        return isSpringBoardBundle()
    }()
    
    ///Preferences
    private let plantsAnimationStyle = PreferenceCollection.PlantsAnimationStyle.getStyle()
    private let plantsSize = PreferenceCollection.PlantsSize.setSize()
    
    //MARK: - Initializer
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupGroundContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlants()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupViewConstraints()
        setupMailBoxView()
        updatePlants()
    }
    
    //MARK: - Functions (Plants)
    private func isSpringBoardBundle() -> Bool {
        Bundle.main.bundleIdentifier == "com.apple.springboard" ? true : false
    }
    
    func setupGroundContainerView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        lastUpdateX = 1.0
        imageViews = NSMutableArray()
        if isSpringBoard {
            lastUpdateX = 20.0
        }
        
        /*
         
         Observers for Applications to keep the animation needs to be implemented here
         Not implemented as this Project hooks in Springboard only
         See the included Subproject for reference
         
        */
    }
    
    private func setupViewConstraints() {
        guard let superview = self.superview else { return }
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: -25.0 + (isSpringBoard ? 0.0 : -3.0)),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0),
            self.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
    private func setupMailBoxView() {
        guard let superview = self.superview, tweakPrefs.birdsEnabled, tweakPrefs.mailBoxEnabled else { return }

        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleBadgeState))
        recognizer.direction = [.left, .right]
        superview.addGestureRecognizer(recognizer)
        
        self.addSubview(mailBoxView)
        NSLayoutConstraint.activate([
            mailBoxView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -35),
            mailBoxView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupPlantImageView(withPlant image: UIImage) -> UIImageView {
        let imageView: UIImageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViews.add(imageView)
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lastUpdateX),
            imageView.widthAnchor.constraint(equalToConstant: image.size.width),
            imageView.heightAnchor.constraint(equalToConstant: image.size.height)
        ])
        
        lastUpdateX += image.size.width + CGFloat(plantsSize)
        return imageView
    }
    
    private func updatePlants() {
        offset = 0.0
        if isSpringBoard { offset += 20.0 }

        while (self.point(inside: CGPoint(x: lastUpdateX, y: 1), with: nil)) {
            guard let plantImage: UIImage = MMAssets.randomImage(withPrefix: "plant") else { return }
            if !(self.point(inside: CGPoint(x: lastUpdateX + offset, y: 1), with: nil)) || !(self.point(inside: CGPoint(x: lastUpdateX + plantImage.size.width, y: 1), with: nil)) { break }
            
            let plantImageView: UIImageView = setupPlantImageView(withPlant: plantImage)
            animatePlants(plantImageView)
        }
        
        for i in stride(from: imageViews.count - 1, through: 0, by: -1) {
            if ((imageViews[i] as AnyObject).frame.origin.x + offset) > self.frame.size.width {
                (imageViews[i] as AnyObject).removeFromSuperview()
                imageViews.removeObject(at: i)
            }
        }
    }
    
    private func animatePlants(_ imageView: UIImageView) {
        animator = PlantAnimation(animationStyle: plantsAnimationStyle, for: imageView)
    }
    
    @objc private func handleBadgeState() {
        let applicationIdentifier = SBApplicationManager.shared.result.map { $0.name }.joined(separator: "\n")
        if !applicationIdentifier.isEmpty && mailBoxView.isDeliveryBirdLanded {
            let alertController = UIAlertController(title: "MobileMeadow Reborn", message: "The following applications have registered notifications:\n\n\(applicationIdentifier)", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(dismissAction)
            
            MMAirLayerViewController.shared.present(alertController, animated: true)
        }
    }
}
