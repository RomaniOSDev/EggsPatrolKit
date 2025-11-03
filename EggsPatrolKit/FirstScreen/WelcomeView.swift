
import UIKit
import SnapKit

class WelcomeView: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    private var isFirstLaunch = false
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let appImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "appImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "playButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
        viewModel.getQuizGameData()
        isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch.key")
        if isFirstLaunch == false {
            UserDefaults.standard.setValue(0, forKey:  SaveQuizResult.easy.key)
            UserDefaults.standard.setValue(0, forKey:  SaveQuizResult.medium.key)
            UserDefaults.standard.setValue(0, forKey:  SaveQuizResult.hard.key)
            
            UserDefaults.standard.setValue(0, forKey:  SavePuzzleResult.easy.key)
            UserDefaults.standard.setValue(0, forKey:  SavePuzzleResult.hard.key)
            UserDefaults.standard.setValue(true, forKey:  "isFirstLaunch.key")
        }
        UIView.animate(withDuration: 0.2) {
            self.appImage.alpha = 1.0
            self.playButton.alpha = 1.0
        }
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(appImage)
        appImage.alpha = 0.0
        view.addSubview(playButton)
        playButton.alpha = 0.0
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            viewModel.viewAnimate(view: playButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.nextView()
            }
            case 2:
            break
        default:
            break
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        appImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        playButton.snp.makeConstraints { make in
            make.width.equalTo(137)
            make.height.equalTo(166)
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(30)
        }
    }
}
extension WelcomeView {
    func nextView() {
        let controller = MainController()
        navigationController?.viewControllers = [controller]
    }
}

