

import UIKit
import SnapKit
import CoreData

class MainController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var settingsButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "settingsButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
  
    
    
    
    
    
    private lazy var roadButton: UIButton = {
        let view = UIButton()
        view.tag = 2
        view.setBackgroundImage(UIImage(named: "roadButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var pezzleButton: UIButton = {
        let view = UIButton()
        view.tag = 3
        view.setBackgroundImage(UIImage(named: "pezzleButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var quizButton: UIButton = {
        let view = UIButton()
        view.tag = 4
        view.setBackgroundImage(UIImage(named: "quizButton"), for: .normal)
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
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            viewModel.viewAnimate(view: settingsButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.openSettings()
            }
            case 2:
            viewModel.viewAnimate(view: roadButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = SafeRoadController()
                self.navigationController?.pushViewController(vc, animated: false)
            }
            case 3:
            viewModel.viewAnimate(view: pezzleButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.openSelectView(.puzzle)
            }
            case 4:
            viewModel.viewAnimate(view: quizButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.openSelectView(.quiz)
            }
        default:
            break
        }
    }
    private func openSettings() {
        let vc = SettingsController()
        navigationController?.pushViewController(vc, animated: false)
    }
    private func openSelectView(_ type: SelectTypeGame) {
        let vc = SelectViewController()
        vc.selectType = type
        navigationController?.pushViewController(vc, animated: false)
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(settingsButton)
        
        view.addSubview(roadButton)
        view.addSubview(pezzleButton)
        view.addSubview(quizButton)
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(64)
            make.height.equalTo(85)
        }
        
        roadButton.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(pezzleButton.snp.top).inset(-15)
        }
        pezzleButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(120)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        quizButton.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(pezzleButton.snp.bottom).offset(15)
        }
    }
}
