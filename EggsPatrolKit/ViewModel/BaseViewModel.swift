
import UIKit
import StoreKit

class BaseViewModel {
    
    static let shared = BaseViewModel()
    private var quizData: ResnonseGameData?
    
    var isErrorRequest: ((Bool, InitState_EP, String) -> Void)?

    func viewAnimate(view: UIView) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            view.transform = CGAffineTransform(scaleX: 0.95,
                                               y: 0.95)
        }, completion: { finished in
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                view.transform = CGAffineTransform(scaleX: 1,
                                                   y: 1)
            })
        })
    }
    func isOldIphone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.screen.bounds.height > 800
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let modelName = UIDevice.current.modelName
            let oldiPadModels = ["iPad4", "iPad5", "iPad6", "iPad7", "iPad8", "iPad2", "iPad3", "Ipad", "iPadOS", "iPad"]
            return !oldiPadModels.contains(where: modelName.contains)
        }
        return true
    }
    func setCurrectTitle_EP(_ inputText: String) -> NSAttributedString {
         let attributedStr = NSMutableAttributedString(string: inputText)
         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.lineSpacing = 4
         paragraphStyle.paragraphSpacing = 8
         let regularAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 16, weight: .medium),
             .paragraphStyle: paragraphStyle
         ]
        attributedStr.addAttributes(regularAttributes, range: NSRange(location: 0, length: inputText.utf16.count))
         let titleAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 20, weight: .bold),
             .paragraphStyle: paragraphStyle
         ]
         let M_Attributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
             .paragraphStyle: paragraphStyle
         ]
         let titlePattern = "^\\d+\\..*$"
         guard let titleRegex = try? NSRegularExpression(pattern: titlePattern,  options: [.anchorsMatchLines]) else {
             return attributedStr
         }
         let M_Pattern = "^Moral:.*$"
         guard let M_Regex = try? NSRegularExpression(pattern: M_Pattern, options: [.anchorsMatchLines, .caseInsensitive]) else {
             return attributedStr
         }
         let title_M = titleRegex.matches(in: inputText, options: [], range: NSRange(location: 0, length: inputText.utf16.count))
         for match in title_M {
             attributedStr.addAttributes(titleAttributes, range: match.range)
         }
         let M_Matches = M_Regex.matches(in: inputText, options: [], range: NSRange(location: 0, length: inputText.utf16.count))
         for match in M_Matches {
             attributedStr.addAttributes(M_Attributes, range: match.range)
         }
         return attributedStr
     }
}
extension BaseViewModel {
    func setResnonseGameData() -> ResnonseGameData? {
        return quizData
    }
    @MainActor func getQuizGameData() {
        Task  {
             do {
                 let data = try await getGameData()
                 DispatchQueue.main.async { [weak self] in
                     guard let self else { return }
                     quizData = data
                 }
             } catch {
                 print("ERROR: \(error)")
             }
         }
    }
    private func getGameData() async throws -> ResnonseGameData {
        guard let url = URL(string: AppData_EP.url.value) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(ResnonseGameData.self,
                                            from: data)
        case 404:
            throw NetworkError.notDataFound
        default:
            throw NetworkError.serverCodeError(
                statusCode: httpResponse.statusCode,
                message: httpResponse.debugDescription
            )
        }
    }
    func makeRequest(_ link: String) {
        guard let url = URL(string: link) else {
            DispatchQueue.main.async {
                self.isErrorRequest?(true, .unknown_EP, "Invalid URL")
            }
            return
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error as NSError?,
                error.code == NSURLErrorTimedOut {
                DispatchQueue.main.async {
                    self.isErrorRequest?(true, .firstLaunch_EP, "Timeout: No response from server in 30 seconds \(error.code)")
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.isErrorRequest?(true, .baseGame_EP, "Error: \(error.localizedDescription)")
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.isErrorRequest?(true, .baseGame_EP, "No valid response received")
                }
                return
            }
            if httpResponse.statusCode == 404 {
                DispatchQueue.main.async {
                    self.isErrorRequest?(true, .baseGame_EP, "Error: \(httpResponse.statusCode)")
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.isErrorRequest?(true, .baseGame_EP, "Server error: \(httpResponse.statusCode)")
                }
                return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    DispatchQueue.main.async {
                        self.isErrorRequest?(true, .baseGame_EP, "Error parsing JSON \(json)")
                    }
                    return
                }
            }
            if let finalURL = httpResponse.url?.absoluteString {
                DispatchQueue.main.async {
                    self.isErrorRequest?(false, .correctlyOffer_EP, finalURL)
                }
            } else {
                DispatchQueue.main.async {
                    self.isErrorRequest?(true, .baseGame_EP, "No redirect URL available")
                }
            }
        }
        task.resume()
    }
}

// _____________ MARK: - Extension

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier,
            element in
            guard let value = element.value as? Int8,
                  value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

extension SKStoreReviewController {
    public static func requestRateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverCodeError(statusCode: Int, message: String?)
    case notDataFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL адрес"
        case .invalidResponse: return "Некорректный ответ сервера"
        case .serverCodeError(let statusCode, let message): return "Ошибка сервера (\(statusCode)): \(message ?? "нет описания")"
        case .notDataFound: return "Данные не найдены"
        }
    }
}

struct ResnonseGameData: Codable {
    let quize: Quize
    let saferoad: String
}
struct Quize: Codable {
    let easy, medium, hard: [Quiz]

    enum CodingKeys: String, CodingKey {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}
struct Quiz: Codable {
    let question: String
    let answers: [String]
    let correctIndex: Int

    enum CodingKeys: String, CodingKey {
        case question, answers
        case correctIndex = "correct_index"
    }
}
