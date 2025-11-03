
import UIKit
import SnapKit

enum SelectTypeGame {
    case quiz
    case puzzle
}
enum HadrModeGame {
    case easy
    case medium
    case hard
}

class SelectViewController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    var stackHeight: CGFloat = 0
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let selectImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "selectImageTop")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var quizImage = ["selectEasy", "selectMedium", "selectHard"]
    private lazy var puzzleImage = ["selectEasy", "selectHard"]
    private lazy var arrayImage: [String] = []
    
    lazy var selectType: SelectTypeGame = .quiz {
        didSet {
            switch selectType {
            case .quiz:
                arrayImage.append(contentsOf: quizImage)
                stackHeight = 350
            case .puzzle:
                stackHeight = 230
                arrayImage.append(contentsOf: puzzleImage)
            }
        }
    }
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "backGameButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        view.tag = 1
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
        setupImageButtons()
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(backButton)
        view.addSubview(selectImageView)
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
    private func setupImageButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(stackHeight)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(100)
        }
        if viewModel.isOldIphone() == false {
            stackView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(20)
            }
        }
        for (index, imageName) in arrayImage.enumerated() {
            let button = createImageButton(imageName: imageName, tag: index)
            stackView.addArrangedSubview(button)
        }
    }
    private func createImageButton(imageName: String,
                                   tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(imageButtonTapped),
                         for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return button
    }
    @objc private func imageButtonTapped(_ sender: UIButton) {
        viewModel.viewAnimate(view: sender)
        switch selectType {
        case .quiz:
            switch sender.tag + 1 {
            case 1:
                openQuiz(.easy)
            case 2:
                openQuiz(.medium)
            case 3:
                openQuiz(.hard)
            default:
                break
            }
        case .puzzle:
            switch sender.tag + 1 {
            case 1:
                openPuzzle(.easy)
            case 2:
                openPuzzle(.hard)
            default:
                break
            }
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(15)
            make.height.equalTo(50)
            make.width.equalTo(95)
        }
        selectImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalTo(174)
        }
    }
}
extension SelectViewController {
    func openQuiz(_ mode: HadrModeGame) {
        let controller = QuizGameController()
        controller.selectMode = mode
        navigationController?.pushViewController(controller, animated: false)
    }
    func openPuzzle(_ mode: HadrModeGame) {
        let controller = SelectPuzzle()
        switch mode {
        case .easy:
            controller.selectMode = .easy
            controller.data = puzzleImagesData.filter { $0.type == .yeasy }
        case .medium:
            break
        case .hard:
            controller.selectMode = .hard
            controller.data = puzzleImagesData.filter { $0.type == .hard }
        }
        navigationController?.pushViewController(controller, animated: false)
    }
}
