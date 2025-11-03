
import UIKit
import SnapKit

class ResultViewController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    let defaults = UserDefaults.standard
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "closwButton"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    
    
    
    private let resultQuizView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "resultQuiz")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var quiEasy: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.text = "\(defaults.integer(forKey: SaveQuizResult.easy.key))/10"
        return view
    }()
    private lazy var quiMedium: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.text = "\(defaults.integer(forKey: SaveQuizResult.medium.key))/10"
        return view
    }()
    private lazy var quiHard: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.text = "\(defaults.integer(forKey: SaveQuizResult.hard.key))/10"
        return view
    }()
    
    private let resultPuzzleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "resultPuzzle")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private lazy var puzzleEasy: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.text = "10/10"
        return view
    }()
    private lazy var puzzleHard: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.text = "10/10"
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
        
        view.addSubview(resultQuizView)
        resultQuizView.addSubview(quiEasy)
        resultQuizView.addSubview(quiMedium)
        resultQuizView.addSubview(quiHard)
        
        view.addSubview(resultPuzzleView)
        resultPuzzleView.addSubview(puzzleEasy)
        resultPuzzleView.addSubview(puzzleHard)
        
        
//        quiEasy.backgroundColor = .red
//        quiMedium.backgroundColor = .red
//        quiHard.backgroundColor = .red
//        puzzleEasy.backgroundColor = .red
//        puzzleHard.backgroundColor = .red
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
        resultQuizView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(backgroundImageView.snp.centerY)
        }
        quiEasy.snp.makeConstraints { make in
            make.top.equalTo(resultQuizView.snp.centerY).offset(5)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(22)
            make.left.equalTo(resultQuizView.snp.centerX)
        }
        
        quiMedium.snp.makeConstraints { make in
            make.top.equalTo(quiEasy.snp.bottom).offset(10)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(22)
            make.left.equalTo(resultQuizView.snp.centerX)
        }
        quiHard.snp.makeConstraints { make in
            make.top.equalTo(quiMedium.snp.bottom).offset(10)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(22)
            make.left.equalTo(resultQuizView.snp.centerX)
        }
        
        resultPuzzleView.snp.makeConstraints { make in
            make.top.equalTo(resultQuizView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(20)
            make.bottomMargin.equalToSuperview().inset(30)
        }
        puzzleEasy.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(22)
            make.left.equalTo(resultPuzzleView.snp.centerX).offset(-10)
            make.bottom.equalTo(puzzleHard.snp.top).inset(-55)
        }
        puzzleHard.snp.makeConstraints { make in
            make.top.equalTo(resultPuzzleView.snp.centerY).offset(12)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(22)
            make.left.equalTo(resultPuzzleView.snp.centerX).offset(-10)
        }
        if viewModel.isOldIphone() == false {
            quiEasy.snp.updateConstraints { make in
                make.top.equalTo(resultQuizView.snp.centerY)
            }
            
            quiMedium.snp.updateConstraints { make in
                make.top.equalTo(quiEasy.snp.bottom).offset(5)
            }
            quiHard.snp.updateConstraints { make in
                make.top.equalTo(quiMedium.snp.bottom).offset(5)
            }
            puzzleEasy.snp.updateConstraints { make in
                make.bottom.equalTo(puzzleHard.snp.top).inset(-43)
            }
            puzzleHard.snp.updateConstraints { make in
                make.top.equalTo(resultPuzzleView.snp.centerY).offset(8)
            }
        }
    }
}
enum SaveQuizResult {
    case easy
    case medium
    case hard
    var key: String {
        switch self {
        case .easy: return "SaveQuizResult_Easy"
        case .medium: return "SaveQuizResult_Medium"
        case .hard: return "SaveQuizResult_Hard"
        }
    }
}
enum SavePuzzleResult {
    case easy
    case hard
    var key: String {
        switch self {
        case .easy: return "SavePuzzleResult_Easy"
        case .hard: return "SavePuzzleResult_Hard"
        }
    }
}
