
import Foundation

let applicationID = 6751494044

enum AppData_EP {
    case appId
    case privacy
    case url
    case offer
    case appsFlyerKey
    case initKey
    case linkKey
    case correctlyOfferLink
    var value: String {
        switch self {
        case .appId: return "id\(applicationID)"
        case .privacy: return "https://www.termsfeed.com/live/841c7c33-d56c-4ae7-9d1d-9025f7ac1e53"
        case .url: return "https://crossyluck.site/H8SGSR2M?sub_id_10=quiz"
        case .offer: return "https://eggspatrol.xyz/info?appsflyer_id="
        case .appsFlyerKey: return "4uZ5JcaNsdAdEBzpKz7p9b"
        case .initKey: return "state_EggsPatrol"
        case .linkKey: return "link_EggsPatrol"
        case .correctlyOfferLink: return UserDefaults.standard.string(forKey: AppData_EP.linkKey.value) ?? ""
        }
    }
}
enum InitState_EP: String {
    case unknown_EP
    case firstLaunch_EP
    case correctlyOffer_EP
    case baseGame_EP
}
enum OneSignalValue_EP {
    case appID_EP
    var key: String {
        switch self {
        case .appID_EP : return "8268550c-0d76-408c-9963-f79dd236138b"
        }
    }
}
enum CustomNotification_EP {
    case none
    case directToWeb
    case second
    case third
    
    var value: String {
        switch self {
        case .none: return ""
        case .directToWeb: return "direct.the.user_web"
        case .second: return ""
        case .third: return ""
        }
    }
    static func fromValye(_ name: String?) -> CustomNotification_EP {
        guard let name else { return .none }
        let lowercasedName = name.lowercased()
        for category in [directToWeb,
                         second,
                         third] {
            if category.value.lowercased() == lowercasedName {
                return category
            }
        }
        return .none
    }
}
