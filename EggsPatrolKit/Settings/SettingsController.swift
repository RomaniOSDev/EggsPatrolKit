
import UIKit
import SnapKit
import StoreKit

class SettingsController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
   
    private lazy var resultButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "resultButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var privacyButton: UIButton = {
        let view = UIButton()
        view.tag = 2
        view.setBackgroundImage(UIImage(named: "privacyButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var infoButton: UIButton = {
        let view = UIButton()
        view.tag = 3
        view.setBackgroundImage(UIImage(named: "infoButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var rateButton: UIButton = {
        let view = UIButton()
        view.tag = 4
        view.setBackgroundImage(UIImage(named: "rateButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.tag = 5
        view.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
        
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        
        view.addSubview(resultButton)
        view.addSubview(privacyButton)
        view.addSubview(infoButton)
        view.addSubview(rateButton)
        
        view.addSubview(backButton)
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            viewModel.viewAnimate(view: resultButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = ResultViewController()
                self.navigationController?.pushViewController(vc, animated: false)
            }
            case 2:
            viewModel.viewAnimate(view: privacyButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.openWebController()
            }
        case 3:
            viewModel.viewAnimate(view: infoButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = InfoViewController()
                self.navigationController?.pushViewController(vc, animated: false)
            }
        case 4:
            viewModel.viewAnimate(view: rateButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                SKStoreReviewController.requestRateApp()
            }
        case 5:
            viewModel.viewAnimate(view: backButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.popViewController(animated: false)
            }
        default:
            break
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
        resultButton.snp.makeConstraints { make in
            make.bottom.equalTo(privacyButton.snp.top).inset(-15)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(100)
        }
        privacyButton.snp.makeConstraints { make in
            make.bottom.equalTo(infoButton.snp.top).inset(-15)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(120)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(90)
        }
        rateButton.snp.makeConstraints { make in
            make.top.equalTo(infoButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(90)
        }
        
        backButton.snp.makeConstraints { make in
            make.bottomMargin.equalToSuperview().inset(20)
            make.height.equalTo(55)
            make.width.equalTo(273)
            make.centerX.equalToSuperview()
        }
    }
}
extension SettingsController {
    func openWebController() {
        let controller = OpenLinkController()
        controller.isPolicy = true
        controller.loadURL(AppData_EP.privacy.value)
        navigationController?.pushViewController(controller, animated: false)
    }
}
