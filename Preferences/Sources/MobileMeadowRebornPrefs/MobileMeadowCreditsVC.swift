import Preferences
import MobileMeadowRebornPrefsC

class MobileMeadowCreditsVC: PSListController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationBarManager.setNavBarThemed(enabled: true, vc: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NavigationBarManager.setNavBarThemed(enabled: false, vc: self)
    }
    
    //MARK: - Actions
    private func loadWebsiteFromString(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func handleRebornDeveloper() {
        //@pkgFiles
        loadWebsiteFromString("https://twitter.com/pkgFiles")
    }
    
    @objc func handleTester() {
        //@[π/∞]
        loadWebsiteFromString("https://cypwn.xyz")
    }
    
    @objc func handleWindowsDeveloper() {
        //@samperson
        loadWebsiteFromString("https://twitter.com/samnchiet")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
