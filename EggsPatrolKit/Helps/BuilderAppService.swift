
import UIKit
import AppsFlyerLib

var gameInit = BuilderAppService.shared

class BuilderAppService {
    
    static let shared = BuilderAppService()
    let viewModel = BaseViewModel.shared
    var navigation: UINavigationController?
    
    // MARK: - AppsFlyer
    func setAppsFlyerFor_EPApp(_ delegate: AppsFlyerLibDelegate) {
        AppsFlyerLib.shared().appsFlyerDevKey = AppData_EP.appsFlyerKey.value
        AppsFlyerLib.shared().appleAppID = AppData_EP.appId.value
        AppsFlyerLib.shared().delegate = delegate
    }
    
    
    func saveInitState_EP(_ state: InitState_EP,
                          _ link: String? = nil) {
        switch state {
        case .unknown_EP:
            UserDefaults.standard.removeObject(forKey: AppData_EP.linkKey.value)
        case .firstLaunch_EP:
            break
        case .correctlyOffer_EP:
            if UserDefaults.standard.string(forKey: AppData_EP.linkKey.value) == nil {
                UserDefaults.standard.setValue(link,
                                               forKey: AppData_EP.linkKey.value)
            }
        case .baseGame_EP:
            break
        }
        UserDefaults.standard.set(state.rawValue,
                                  forKey: AppData_EP.initKey.value)
    }
    func setGameState_EP() -> InitState_EP {
        guard let saveState = UserDefaults.standard.string(forKey: AppData_EP.initKey.value) else {
            return .firstLaunch_EP
        }
        return InitState_EP(rawValue: saveState) ?? .firstLaunch_EP
    }
    func openCorrectlyView_EG(_ conversionInfo: [AnyHashable: Any]) {
        switch setGameState_EP() {
        case .unknown_EP:
            openWeb(AppData_EP.privacy.value, true)
        case .firstLaunch_EP:
            setAppsFlyerData_EP(conversionInfo)
        case .correctlyOffer_EP:
            let correctLink = AppData_EP.correctlyOfferLink.value
            openWeb(correctLink, false)
        case .baseGame_EP:
            openFirstView(.baseGame_EP)
        }
    }
    private func setAppsFlyerData_EP(_ conversionInfo: [AnyHashable: Any]) {
        let fullURLString = String(format: "%@%@&%@=%@",
                                   AppData_EP.offer.value,
                                   AppsFlyerLib.shared().getAppsFlyerUID(),
                                   "campaign",
                                   conversionInfo["campaign"] as? String ?? "organic")
        viewModel.makeRequest(fullURLString)
        viewModel.isErrorRequest = { [weak self] error, state, title in
            guard let self = self else { return }
            switch error {
            case true:
                openFirstView(state, title)
            case false:
                saveInitState_EP(state, title)
                openWeb(title, error)
            }
        }
    }  
}
extension BuilderAppService {
    private func openWeb(_ url: String?,
                         _ isPolicy: Bool) {
        let vc = OpenLinkController()
        vc.isPolicy = isPolicy
        vc.loadURL(url ?? AppData_EP.privacy.value)
        navigation?.viewControllers = [vc]
    }
    func openFirstView(_ state: InitState_EP,
                       _ error: String? = nil) {
        print("❌ \(error ?? "no error")")
        saveInitState_EP(state)
        let controller = WelcomeView()
        navigation?.viewControllers = [controller]
    }
}


