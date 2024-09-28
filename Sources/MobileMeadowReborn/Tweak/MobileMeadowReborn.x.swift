import Orion
import MobileMeadowRebornC

// MobileMeadow Reborn - Turn your phone into a meadow. Add flowers to your apps. Let birds fly on your screen.
// Rewrite for modern iOS 14.0 - 16.7.10
// based on original from @pixelomer: https://github.com/pixelomer/MobileMeadow
//MARK: - Variables
var tweakPrefs: SettingsModel = SettingsModel()

//MARK: - Initialize Tweak
struct SBPlants: HookGroup { let plantsEnabled: Bool }
struct SBBirds: HookGroup { let birdsEnabled: Bool }
struct SBMailBoxBird: HookGroup { let mailBoxBirdEnabled: Bool }
struct MobileMeadowReborn: Tweak {
    init() {
        remLog("Preferences Loading...")
        tweakPrefs = TweakPreferences.preferences.loadPreferences()
        
        let dockHook: SBPlants = SBPlants(plantsEnabled: tweakPrefs.plantsEnabled)
        let sceneHook: SBBirds = SBBirds(birdsEnabled: tweakPrefs.birdsEnabled)
        
        switch tweakPrefs.isTweakEnabled {
        case true:
            remLog("Tweak is Enabled! :)")
            if dockHook.plantsEnabled { dockHook.activate() }
            if sceneHook.birdsEnabled {
                sceneHook.activate()
                let sceneExtraHook: SBMailBoxBird = SBMailBoxBird(mailBoxBirdEnabled: tweakPrefs.mailBoxEnabled)
                if sceneExtraHook.mailBoxBirdEnabled { sceneExtraHook.activate() }
            }
        case false:
            remLog("Tweak is Disabled! :(")
            break
        }
    }
}

//MARK: - Hooks
class SBInterfaceHook: ClassHook<SpringBoard> {
    typealias Group = SBBirds
    @Property var airLayerWindow: MMAirLayerWindow?
    
    func applicationDidFinishLaunching(_ application: Any) {
        orig.applicationDidFinishLaunching(application)
        
        if (self.airLayerWindow == nil) {
            self.airLayerWindow = MMAirLayerWindow(frame: UIScreen.main.bounds)
        }
    }
}

class SBDockHook: ClassHook<SBDockIconListView> {
    typealias Group = SBPlants
    @Property var dockGround: MMGroundContainerView?
    
    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        DispatchQueue.once {
            self.createMeadowDockGround()
        }
    }
    
    //orion:new
    func createMeadowDockGround() {
        guard let superview = target.superview else { return }
        if (self.dockGround == nil) {
            self.dockGround = MMGroundContainerView.shared
            remLog("MeadowGroundDock created...")
            superview.addSubview(self.dockGround!)
        }
    }
}

class SBHomescreenHook: ClassHook<SBRootFolderController> {
    typealias Group = SBMailBoxBird
    
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        
        SBApplicationManager.shared.getBadgeValues { result in
            switch result {
            case .success(let value):
                let mailBoxView: MMMailBoxView = MMGroundContainerView.shared.mailBoxView
                if mailBoxView.iconType == .appIcon { mailBoxView.mailBoxIconImageView.image = value.map{ $0.icon }.first }
                if value.count <= 0 {
                    SBBirdsManager.shared.handleFlyingAwayDeliveryBird()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        mailBoxView.handleState(.empty)
                    }
                }
            case .failure(let error):
                remLog(error.localizedDescription)
            }
        }
    }
}

class NCNotificationHook: ClassHook<NCNotificationShortLookViewController> {
    typealias Group = SBMailBoxBird
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        SBApplicationManager.shared.getBadgeValues { result in
            switch result {
            case .success(let value):
                let mailBoxView = MMGroundContainerView.shared.mailBoxView
                if mailBoxView.iconType == .appIcon { mailBoxView.mailBoxIconImageView.image = value.map{ $0.icon }.first }
                if value.count > 0 {
                    SBBirdsManager.shared.handleLandingDeliveryBird()
                }
            case .failure(let error):
                remLog(error.localizedDescription)
            }
        }
    }
}
