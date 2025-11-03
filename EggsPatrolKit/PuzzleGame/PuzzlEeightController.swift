
import UIKit
import SnapKit

class PuzzlEeightController: UIViewController {
    
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
    private var offset: CGFloat = 0
    private var state: ViewState = .process
    private let userDefaults = UserDefaults.standard

    private var elementSizes_EP = CGSize()
    private var elementOrigins: [CGPoint] = []
    private var elementFrames_EP: [CGRect] = []
    private var sizePiece = CGSize()
    private var views: [UIView] = []
    private var timer: Timer?
    private var seconds: Int = 0
    private let resultView = PuzzleResult()
   
    
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
        if viewModel.isOldIphone() == true {
            offset = 60
        } else {
            offset = 20
        }
        setupeSizeElementEeight(offset)
        setupeSubview()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupePuzzleElementEeight(index)
        startTimerViewEeight()
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(timerTitle)
        view.addSubview(puzzleFullImage)
        view.addSubview(backButton)
        view.addSubview(resultView)
        resultView.isHidden = true
        resultView.navigation = navigationController
    }
    private func startTimerViewEeight() {
        timer?.invalidate()
        seconds = 0
        updateTimeTitleEeight()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
            self.updateTimeTitleEeight()
        }
    }
    private func updateTimeTitleEeight() {
        let minutes = seconds / 60
        let secs = seconds % 60
        let formatted = String(format: "%d:%02d", minutes, secs)
        timerTitle.text = formatted
    }
    private func stopTimerViewEeight() {
        timer?.invalidate()
        timer = nil
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            navigationController?.popToRootViewController(animated: false)
        case 2:
            break
        default:
            break
        }
    }
    private func setupeSizeElementEeight(_ offset: CGFloat) {
        let puzzleFrame = puzzleFullImage.frame
        elementSizes_EP = CGSize(width: puzzleFrame.width / 2,
                             height: puzzleFrame.height / 4)
        sizePiece = CGSize(width: elementSizes_EP.width * 0.9,
                           height: elementSizes_EP.height * 0.9)
        
        let leftColumnX = puzzleFrame.minX
        let rightColumnX = puzzleFrame.minX + elementSizes_EP.width
        
        let startY = puzzleFrame.minY + offset
        
        
        elementOrigins = [ CGPoint(x: leftColumnX, y: startY),
                           CGPoint(x: leftColumnX, y: startY + elementSizes_EP.height),
                           CGPoint(x: leftColumnX, y: startY + elementSizes_EP.height * 2),
                           CGPoint(x: leftColumnX, y: startY + elementSizes_EP.height * 3),
            
                           CGPoint(x: rightColumnX, y: startY),
                           CGPoint(x: rightColumnX, y: startY + elementSizes_EP.height),
                           CGPoint(x: rightColumnX, y: startY + elementSizes_EP.height * 2),
                           CGPoint(x: rightColumnX, y: startY + elementSizes_EP.height * 3)]
    }
    private func setupePuzzleConstraintEeight(_ tag: Int,
                                              _ piece: UIImageView) {
        totalItemsCollected += 1
        let isLeftColumn = tag < 4
        let row = isLeftColumn ? tag : tag - 4
        let xPosition = isLeftColumn ? elementOrigins[0].x : elementOrigins[4].x
        let yPosition = elementOrigins[0].y + CGFloat(row) * elementSizes_EP.height
        piece.transform = .identity
        UIView.animate(withDuration: 0.3) {
            piece.frame = CGRect(
                x: xPosition,
                y: yPosition,
                width: self.elementSizes_EP.width,
                height: self.elementSizes_EP.height
            )
            piece.layer.borderWidth = 0
            piece.contentMode = .scaleToFill
        }
        views.append(piece)
        if totalItemsCollected == 8 {
            completePuzzleEeight()
        }
    }
    private func setupePuzzleElementEeight(_ index: Int) {
        totalItemsCollected = 0
        views.forEach { $0.removeFromSuperview() }
        views.removeAll()
        elementFrames_EP.removeAll()
        elementOrigins.removeAll()
        view.subviews.forEach { subview in
            if subview.layer.borderColor == UIColor.blue.withAlphaComponent(0.2).cgColor {
                subview.removeFromSuperview()
            }
        }
        puzzleFullImage.image = puzzleData?.preview
        view.layoutIfNeeded()
        setupeSizeElementEeight(offset)
        for origin in elementOrigins {
            let frame = CGRect(origin: origin,
                               size: elementSizes_EP)
            elementFrames_EP.append(frame)
            let slotView = UIView(frame: frame)
            slotView.layer.borderWidth = 0
            slotView.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            slotView.backgroundColor = .clear
            view.insertSubview(slotView,
                               belowSubview: puzzleFullImage)
        }
        let scaledSize = CGSize(
            width: elementSizes_EP.width * 0.7,
            height: elementSizes_EP.height * 0.7
        )
        let bottomMargin: CGFloat = 20
        let horizontalSpacing: CGFloat = 8
        let verticalSpacing: CGFloat = 8
        let itemsInRow = [3, 3, 2]
        
        var currentIndex = 0
        for row in 0..<3 {
            let itemsCount = itemsInRow[row]
            let totalRowWidth = (scaledSize.width * CGFloat(itemsCount)) + (horizontalSpacing * CGFloat(itemsCount - 1))
            let startX = (view.frame.width - totalRowWidth) / 2
            let rowY = view.frame.height - scaledSize.height * CGFloat(3 - row) - CGFloat(2 - row) * verticalSpacing - bottomMargin - view.safeAreaInsets.bottom
            
            for col in 0..<itemsCount {
                guard let elements = elements else { return }
                guard currentIndex < elements.count else { continue }
                
                let x = startX + CGFloat(col) * (scaledSize.width + horizontalSpacing)
                let piece = UIImageView(image: UIImage(named: elements[currentIndex]))
                piece.frame = CGRect(x: x, y: rowY, width: scaledSize.width, height: scaledSize.height)
                piece.isUserInteractionEnabled = true
                piece.tag = currentIndex
                piece.contentMode = .scaleAspectFill
                piece.clipsToBounds = true
                view.addSubview(piece)
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(movingEeight))
                piece.addGestureRecognizer(pan)
                
                currentIndex += 1
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.puzzleFullImage.alpha = 0.2
        }
    }
    @objc func movingEeight(_ gesture: UIPanGestureRecognizer) {
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
                setupePuzzleConstraintEeight(pieceIndex,
                                             piece)
                piece.isUserInteractionEnabled = false
            } else {
                returnToInitialPositionEeight(piece)
            }
        default:
            break
        }
    }
    private func returnToInitialPositionEeight(_ piece: UIImageView) {
        var targetRow = 0
        var targetCol = piece.tag
        if piece.tag >= 6 { targetRow = 2; targetCol = piece.tag - 6 }
        else if piece.tag >= 3 { targetRow = 1; targetCol = piece.tag - 3 }
        let itemsInRow = [3, 3, 2]
        let itemsCount = itemsInRow[targetRow]
        let totalRowWidth = (sizePiece.width * CGFloat(itemsCount)) + (8 * CGFloat(itemsCount - 1))
        let startX = (view.frame.width - totalRowWidth) / 2
        let rowY = view.frame.height - sizePiece.height * CGFloat(3 - targetRow) - CGFloat(2 - targetRow) * 8 - 20 - view.safeAreaInsets.bottom
        let x = startX + CGFloat(targetCol) * (sizePiece.width + 8)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: []) {
            piece.frame = CGRect(
                x: x,
                y: rowY,
                width: self.sizePiece.width,
                height: self.sizePiece.height
            )
        }
    }
    private func completePuzzleEeight() {
        saveDataEeight()
        result += 1
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.puzzleFullImage.alpha = 0
            self.views.forEach { $0.alpha = 0 }
        }) { _ in
            self.totalItemsCollected = 0
            self.views.forEach { $0.removeFromSuperview() }
            self.views.removeAll()
            self.elementFrames_EP.removeAll()
            self.elementOrigins.removeAll()
            
            self.offset = 0
            if self.index < hardImageNumbers - 1 {
                self.index += 1
                UIView.animate(withDuration: 0.5) {
                    self.puzzleFullImage.alpha = 0.2
                }
                self.setupePuzzleElementEeight(self.index)
            } else {
                self.stopTimerViewEeight()
                self.openResult()
            }
        }
    }
    private func saveDataEeight() {
        let myValuy = UserDefaults.standard.integer(forKey: SavePuzzleResult.hard.key)
        if result > myValuy {
            UserDefaults.standard.setValue(result,
                                           forKey: SavePuzzleResult.hard.key)
        }
    }
    private func addConstraints() {
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
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(33)
            make.width.equalTo(75)
        }
        puzzleFullImage.snp.makeConstraints { make in
            make.top.equalTo(timerTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.height / 2)
        }
        resultView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PuzzlEeightController {
    func openResult() {
        resultView.isHidden = false
    }
}
