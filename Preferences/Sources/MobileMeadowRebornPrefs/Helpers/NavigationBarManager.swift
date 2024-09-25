import UIKit

struct NavigationBarManager {
    
    static func setNavBarThemed(enabled isEnabled: Bool, vc: UIViewController) {
        if #available(iOS 13.0, *) {
            guard let bar: UINavigationBar = vc.navigationController?.navigationController?.navigationBar else { return }
            let appearance = UINavigationBarAppearance()
            
            if isEnabled {
                // NavigationBar background color
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(red: 63/255, green: 201/255, blue: 255/255, alpha: 1.0)
                appearance.shadowColor = UIColor.clear
                
                bar.isTranslucent = false
                bar.tintColor = UIColor.white
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = appearance
            } else {
                bar.isTranslucent = true
                bar.tintColor = UINavigationBar.appearance().tintColor
                bar.standardAppearance = UINavigationBar.appearance().standardAppearance
                bar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
            }
            
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
