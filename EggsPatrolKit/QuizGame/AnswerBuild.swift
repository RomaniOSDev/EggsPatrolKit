
import UIKit
import SnapKit

final class AnswerBuild: UIView {
    
    let viewModel = BaseViewModel.shared
    var answer = 0
    var didSelectAnswer: ((Int) -> Void)?
    
   var stackButtonView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    var answerButtonView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.black,
                           for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 27,
                                            weight: .bold)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
        view.titleLabel?.textAlignment = .center
        view.setBackgroundImage(UIImage(named: "answerButtonDef"), for: .normal)
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
        answerButtonView.addTarget(self,
                               action: #selector(tapButtonAnswer),
                               for: .touchUpInside)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubview() {
        self.addSubview(stackButtonView)
        stackButtonView.addSubview(answerButtonView)
        answerButtonView.alpha = 0.0
    }
    func configureButton(title: String,
                         answer: Int) {
        self.answer = answer
        answerButtonView.setBackgroundImage(UIImage(named: "answerButtonDef"),
                                        for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) { [weak self] in
            self?.answerButtonView.setTitle(title,
                                       for: .normal)
        }
        switch answerButtonView.tag {
        case 0:
            answerButtonView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                guard let self else { return }
                answerButtonView.setTitle(title, for: .normal)
            }
        case 1:
            answerButtonView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) { [weak self] in
                guard let self else { return }
                answerButtonView.setTitle(title, for: .normal)
            }
        case 2:
            answerButtonView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) { [weak self] in
                guard let self else { return }
                answerButtonView.setTitle(title, for: .normal)
            }
        default:
            break
        }
    }
    @objc func tapButtonAnswer(_ sender: UIButton) {
        viewModel.viewAnimate(view: answerButtonView)
        answerButtonView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            if answer == sender.tag {
                answerButtonView.setBackgroundImage(UIImage(named: "answerButtonYES"), // yes
                                                for: .normal)
            } else {
                answerButtonView.setBackgroundImage(UIImage(named: "answerButtonNO"), // no
                                                for: .normal)
            }
        }
        didSelectAnswer?(sender.tag)
        stackButtonView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) { [weak self] in
            guard let self else { return }
            answerButtonView.setBackgroundImage(UIImage(named: "answerButtonDef"), // gefault
                                            for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0 ) { [weak self] in
            guard let self else { return }
            answerButtonView.isUserInteractionEnabled = true
        }
    }
    private func setupeConstraints() {
        stackButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
        answerButtonView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        answerButtonView.titleLabel?.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalToSuperview().inset(15)
        }
    }
}
