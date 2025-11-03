
import UIKit
import SnapKit

class QuizGameController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    let coreData = CoreManager.shared
    var selectMode: HadrModeGame = .easy
    private var currentIndex: Int = 0
    private var result = 0
    private var data: [Quiz] = []
    var isGameOver: Bool = false
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let completedImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "completedImage")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let quizTopImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "quizTopImage")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let questionTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    private var answerSelectView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let quiz = viewModel.setResnonseGameData()?.quize
        switch selectMode {
        case .easy:
            data = quiz?.easy ?? []
        case .medium:
            data = quiz?.medium ?? []
        case .hard:
            data = quiz?.hard ?? []
        }
        setupeAnswerButtonView()
        questionTitle.text = data[currentIndex].question
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(quizTopImageView)
        
        view.addSubview(questionTitle)
        view.addSubview(answerSelectView)
        view.addSubview(backButton)
        
        view.addSubview(completedImageView)
        completedImageView.isHidden = true
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            viewModel.viewAnimate(view: backButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.isGameOver == true {
                    self.navigationController?.popToRootViewController(animated: false)
                } else {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        default:
            break
        }
    }
    private func setupeAnswerButtonView() {
        let answer = data[currentIndex].answers
        answerSelectView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        answer.enumerated().forEach { index, data in
            let view = AnswerBuild()
            view.stackButtonView.isUserInteractionEnabled = true
            view.answerButtonView.tag = index
            view.configureButton(title: data,
                                 answer: self.data[currentIndex].correctIndex)
            view.didSelectAnswer = { [weak self] answerIndex in
                view.stackButtonView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ) { [weak self] in
                    guard let self else { return }
                    if currentIndex < self.data.count - 1 {
                        currentIndex += 1
                        questionTitle.text = self.data[currentIndex].question
                        setupeAnswerButtonView()
                        if answerIndex == self.data[currentIndex].correctIndex {
                            result += 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                            view.stackButtonView.isUserInteractionEnabled = true
                        }
                    } else {
                        openResultView()
                        saveResult()
                    }
                }
            }
            answerSelectView.addArrangedSubview(view)
        }
    }
    private func saveResult() {
        switch selectMode {
        case .easy:
            let myValuy = UserDefaults.standard.integer(forKey:  SaveQuizResult.easy.key)
            if result > myValuy {
                UserDefaults.standard.setValue(result, forKey:  SaveQuizResult.easy.key)
            }
        case .medium:
            let myValuy = UserDefaults.standard.integer(forKey:  SaveQuizResult.medium.key)
            if result > myValuy {
                UserDefaults.standard.setValue(result, forKey:  SaveQuizResult.medium.key)
            }
        case .hard:
            let myValuy = UserDefaults.standard.integer(forKey:  SaveQuizResult.hard.key)
            if result > myValuy {
                UserDefaults.standard.setValue(result,forKey:  SaveQuizResult.hard.key)
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
        quizTopImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(81)
            make.height.equalTo(130)
        }
        questionTitle.snp.makeConstraints { make in
            make.top.equalTo(quizTopImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(20)
        }
        
        answerSelectView.snp.makeConstraints { make in
            make.top.equalTo(questionTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        completedImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.center.equalToSuperview()
        }
    }
}
extension QuizGameController {
    func openResultView() {
        isGameOver = true
        completedImageView.isHidden = false
        answerSelectView.isHidden = true
        
        questionTitle.isHidden = true
        quizTopImageView.isHidden = true
    }
}
