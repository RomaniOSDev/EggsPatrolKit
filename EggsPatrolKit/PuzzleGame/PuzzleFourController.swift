
import UIKit
import SnapKit

class PuzzleFourController: UIViewController {

    var selectMode: HadrModeGame = .easy
    var puzzleData: PuzzleImagesData?
    var elements: [String]?
    let viewModel = BaseViewModel.shared
    var index = 0
    private var totalItemsCollected = 0
    private var result = 0
    enum ViewState {
        case process
        case next
    }
    private let resultView = PuzzleResult()
    
    private var state: ViewState = .process
    private let userDefaults = UserDefaults.standard
    private var elementSize_EP = CGSize()
    private var elementOrigins_EP: [CGPoint] = []
    private var elementFrames_EP: [CGRect] = []
    private var sizePiece_EP = CGSize()
    private let pieceY = UIScreen.main.bounds.height - 220
    private var views: [UIView] = []
    private var timer: Timer?
    private var seconds: Int = 0
    
    
    private lazy var backgroundImageView: UIImageView = {
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
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        view.tag = 1
        return view
    }()
    
    private lazy var puzzleFullImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.alpha = 0.2
        return view
    }()
    
    private let timerTitle: UILabel = {
        let view = UILabel()
        view.text = "0:00"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.textAlignment = .center
        view.textColor = UIColor(named: "brownColorCustom")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPuzzleElement_EP(index)
        startTimerView_EP()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(timerTitle)
        view.addSubview(puzzleFullImage)
        view.addSubview(backButton)
        
        view.addSubview(resultView)
        
        resultView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        resultView.isHidden = true
        resultView.navigation = navigationController
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(15)
            make.height.equalTo(40)
            make.width.equalTo(65)
        }
        
        timerTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(33)
            make.width.equalTo(75)
        }
        
        puzzleFullImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(puzzleFullImage.snp.width).multipliedBy(1.0)
        }
    }
    
    private func setupSizeElement_EP() {
        let puzzleFrame = puzzleFullImage.frame
        elementSize_EP = CGSize(
            width: puzzleFrame.width / 2,
            height: puzzleFrame.height / 2
        )
        sizePiece_EP = CGSize(
            width: elementSize_EP.width * 0.6,
            height: elementSize_EP.height * 0.6
        )
        let leftColumnX = puzzleFrame.minX
        let rightColumnX = puzzleFrame.minX + elementSize_EP.width
        let startY = puzzleFrame.minY
        elementOrigins_EP = [CGPoint(x: leftColumnX, y: startY),
                          CGPoint(x: leftColumnX, y: startY + elementSize_EP.height),
                          
                          CGPoint(x: rightColumnX, y: startY),
                          CGPoint(x: rightColumnX, y: startY + elementSize_EP.height)]
    }
    private func setupPuzzleElement_EP(_ index: Int) {
        totalItemsCollected = 0
        elementFrames_EP.removeAll()
        views.forEach { $0.removeFromSuperview() }
        views.removeAll()
        elementOrigins_EP.removeAll()
        puzzleFullImage.image = puzzleData?.preview
        view.layoutIfNeeded()
        setupSizeElement_EP()
        for origin in elementOrigins_EP {
            let frame = CGRect(origin: origin,
                               size: elementSize_EP)
            elementFrames_EP.append(frame)
            let slotView = UIView(frame: frame)
            slotView.layer.borderWidth = 0
            slotView.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            slotView.backgroundColor = .clear
            view.insertSubview(slotView,
                               belowSubview: puzzleFullImage)
        }
        let scaledSize = CGSize(
            width: elementSize_EP.width * 0.6,
            height: elementSize_EP.height * 0.6
        )
        let bottomMargin: CGFloat = 20
        let horizontalSpacing: CGFloat = 8
        let startY = view.frame.height - scaledSize.height - bottomMargin - view.safeAreaInsets.bottom
        let totalWidth = (scaledSize.width * 4) + (horizontalSpacing * 3)
        if totalWidth > view.frame.width - 40 {
            let scaleFactor = (view.frame.width - 40) / totalWidth
            let adjustedWidth = scaledSize.width * scaleFactor * 0.9
            let adjustedHeight = scaledSize.height * scaleFactor * 0.9
            guard let elements = elements else { return }
            for (i, imageName) in elements.enumerated() {
                let totalAdjustedWidth = (adjustedWidth * 4) + (horizontalSpacing * 3)
                let startX = (view.frame.width - totalAdjustedWidth) / 2
                let x = startX + CGFloat(i) * (adjustedWidth + horizontalSpacing)
                let piece = UIImageView(image: UIImage(named: imageName))
                piece.frame = CGRect(x: x,
                                     y: startY,
                                     width: adjustedWidth,
                                     height: adjustedHeight)
                piece.isUserInteractionEnabled = true
                piece.tag = i
                piece.contentMode = .scaleAspectFill
                piece.clipsToBounds = true
                view.addSubview(piece)
                let pan = UIPanGestureRecognizer(target: self,
                                                 action: #selector(moving))
                piece.addGestureRecognizer(pan)
            }
        } else {
            let startX = (view.frame.width - totalWidth) / 2
            guard let elements = elements else { return }
            for (i, imageName) in elements.enumerated() {
                let x = startX + CGFloat(i) * (scaledSize.width + horizontalSpacing)
                let piece = UIImageView(image: UIImage(named: imageName))
                piece.frame = CGRect(x: x,
                                     y: startY,
                                     width: scaledSize.width,
                                     height: scaledSize.height)
                piece.isUserInteractionEnabled = true
                piece.tag = i
                piece.contentMode = .scaleAspectFill
                piece.clipsToBounds = true
                view.addSubview(piece)
                let pan = UIPanGestureRecognizer(target: self,
                                                 action: #selector(moving))
                piece.addGestureRecognizer(pan)
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.puzzleFullImage.alpha = 0.2
        }
    }
    private func setupPuzzleConstraint_EP(tag: Int,
                                       piece: UIImageView) {
        totalItemsCollected += 1
        let isLeftColumn = tag < 2
        let row = isLeftColumn ? tag : tag - 2
        let xPosition = isLeftColumn ? elementOrigins_EP[0].x : elementOrigins_EP[2].x
        let yPosition = elementOrigins_EP[0].y + CGFloat(row) * elementSize_EP.height
        piece.transform = .identity
        UIView.animate(withDuration: 0.3) {
            piece.frame = CGRect(
                x: xPosition,
                y: yPosition,
                width: self.elementSize_EP.width,
                height: self.elementSize_EP.height
            )
            piece.layer.borderWidth = 0
            piece.contentMode = .scaleToFill
        }
        views.append(piece)
        if totalItemsCollected == 4 {
            completePuzzle()
        }
    }
    @objc private func moving(_ gesture: UIPanGestureRecognizer) {
        guard let piece = gesture.view as? UIImageView else { return }
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .began:
            view.bringSubviewToFront(piece)
            UIView.animate(withDuration: 0.1) {
                piece.transform = CGAffineTransform(scaleX: 1.05,
                                                    y: 1.05)
            }
        case .changed:
            piece.center = CGPoint(
                x: piece.center.x + translation.x,
                y: piece.center.y + translation.y
            )
            gesture.setTranslation(.zero,
                                   in: view)
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.1) {
                piece.transform = .identity
            }
            let pieceIndex = piece.tag
            let targetFrame = elementFrames_EP[pieceIndex]
            let magneticZone = targetFrame.insetBy(dx: -30,
                                                   dy: -30)
            if magneticZone.contains(piece.center) {
                setupPuzzleConstraint_EP(tag: pieceIndex, piece: piece)
                piece.isUserInteractionEnabled = false
            } else {
                returnToInitialPosition_EP(piece)
            }
        default:
            break
        }
    }
    private func returnToInitialPosition_EP(_ piece: UIImageView) {
        let bottomMargin: CGFloat = 20
        let horizontalSpacing: CGFloat = 10
        let startY = view.frame.height - sizePiece_EP.height - bottomMargin - view.safeAreaInsets.bottom
        let totalWidth = (sizePiece_EP.width * 4) + (horizontalSpacing * 3)
        let startX = (view.frame.width - totalWidth) / 2
        let x = startX + CGFloat(piece.tag) * (sizePiece_EP.width + horizontalSpacing)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: []) {
            piece.frame = CGRect(
                x: x,
                y: startY,
                width: self.sizePiece_EP.width,
                height: self.sizePiece_EP.height
            )
        }
    }
    private func startTimerView_EP() {
        timer?.invalidate()
        seconds = 0
        updateTimeTitle_EP()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
            self.updateTimeTitle_EP()
        }
    }
    private func updateTimeTitle_EP() {
        let minutes = seconds / 60
        let secs = seconds % 60
        let formatted = String(format: "%d:%02d", minutes, secs)
        timerTitle.text = formatted
    }
    private func stopTimerView() {
        timer?.invalidate()
        timer = nil
    }
    private func completePuzzle() {
        saveData_EP()
        result += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: 0.5,
                           animations: {
                self.puzzleFullImage.alpha = 0
                self.views.forEach { $0.alpha = 0 }
            }) { _ in
                self.totalItemsCollected = 0
                self.views.forEach { $0.removeFromSuperview() }
                self.views.removeAll()
                self.elementFrames_EP.removeAll()
                self.elementOrigins_EP.removeAll()
                
                if self.index < yeasyImageNumbers - 1 {
                    self.index += 1
                    UIView.animate(withDuration: 0.5) {
                        self.puzzleFullImage.alpha = 0.2
                    }
                    self.setupPuzzleElement_EP(self.index)
                } else {
                    self.stopTimerView()
                    self.openResult()
                }
            }
        }
    }
    private func saveData_EP() {
        let myValuy = UserDefaults.standard.integer(forKey: SavePuzzleResult.easy.key)
        if result > myValuy {
            UserDefaults.standard.setValue(result,
                                           forKey: SavePuzzleResult.easy.key)
        }
    }
    @objc private func tabButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            navigationController?.popToRootViewController(animated: false)
        default:
            break
        }
    }
}
extension PuzzleFourController {
    func openResult() {
        resultView.isHidden = false
    }
}
