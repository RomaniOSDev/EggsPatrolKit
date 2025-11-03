

import UIKit
import SnapKit

class InfoViewController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "closwButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    
    private let infoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "infoImageViewApp")
        view.contentMode = .scaleAspectFit
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
        view.addSubview(closeButton)
        
        view.addSubview(infoImageView)
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popViewController(animated: false)
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
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(80)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottomMargin.equalToSuperview().inset(40)
        }
    }
}
