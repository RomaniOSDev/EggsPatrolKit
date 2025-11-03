
import UIKit
import SnapKit

class FirstScreenController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    private var isFirstLaunch = false
    private let loaderView = UIActivityIndicatorView()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        loaderView.startAnimating()
        setupeSubview()
        addConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.loaderView.stopAnimating()
            self.nextView()
        }
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(loaderView)
        loaderView.color = .white
        loaderView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
extension FirstScreenController {
    func nextView() {
        let controller = WelcomeView()
        navigationController?.viewControllers = [controller]
    }
}
