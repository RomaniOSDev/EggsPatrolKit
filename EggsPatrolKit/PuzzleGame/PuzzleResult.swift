
import UIKit
import SnapKit

final class PuzzleResult: UIView {

    var navigation: UINavigationController?
    
    private var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "backgroundImage")
        return view
    }()
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "backGameButton"), for: .normal)
        view.addTarget(self, action: #selector(backToView), for: .touchUpInside)
        view.tag = 1
        return view
    }()
    private var completedImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "completedPuzzleImage")
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func backToView() {
        navigation?.popToRootViewController(animated: false)
    }
    private func addSubview() {
        addSubview(backgroundImageView)
        addSubview(backButton)
        addSubview(completedImageView)
    }
    private func setupeConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(15)
            make.height.equalTo(40)
            make.width.equalTo(65)
        }
        completedImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.center.equalToSuperview()
        }
    }
}
