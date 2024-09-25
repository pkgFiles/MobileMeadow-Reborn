import UIKit

extension UILabel {
    func createLabelWithFontPath(text: String, fontSize: CGFloat) -> UILabel {
        let ttfName: String = "OpenDyslexic3-Regular.ttf"
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.text = text
        label.font = UIFont(ttfAtPath: prefsAssetsPath + "Fonts/\(ttfName)", size: fontSize)
        
        return label
    }
}
