
import UIKit
import SnapKit

class SafeRoadController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
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
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.contentSize = contentSize
        return view
    }()
    private lazy var contentTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(named: "brownColorCustom")
        view.numberOfLines = 0
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
        let data = viewModel.setResnonseGameData()
        if let text = data?.saferoad {
            let attributedText = viewModel.setCurrectTitle_EP(text)
            titleView.attributedText = attributedText
        }
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentTitleView)
        contentTitleView.addSubview(titleView)
        view.addSubview(backButton)
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
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(15)
            make.height.equalTo(40)
            make.width.equalTo(65)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentTitleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}
//
//let text = "1. The Hurried Hedgehog and the Wise Owl.\n\nHector the Hedgehog was always in a hurry. He would curl into a ball and roll without looking, which often led to bumps and bruises. One day, he was rolling fast to get to the berry patch before his friends. \"I must be the first!\" he thought, zooming towards the road that cut through the forest. Suddenly, a strong wing caught him. It was Olivia the Owl, the forest's crossing guard. She landed gracefully on a signpost. \"Whoooa there, little Hector!\" she hooted. \"Why the great hurry?\" \"The berries, Ms. Owl! I must get there first!\" Hector puffed.  \"Being first is not as important as being safe,\" said Olivia wisely. She pointed her wing at a strange sign by the road. It had a picture of a hedgehog on a black and white stripe. \"Do you know what this means?\" Hector shook his head. \"This is a crosswalk,\" explained Olivia. \"It is a magical safe path. But its magic only works if you use it correctly. You must Stop, Look, and Listen\"\n\nShe taught him:\n- Stop at the edge of the road.\n- Look both ways for any cars, bikes, or scooters.\n- Listen for any engine sounds you might not see.\nHector did as he was told. He stopped, looked left, looked right, and listened carefully. Once the road was completely clear, he walked safely across the stripes. He got to the berry patch a moment later, but he felt safe and proud. From that day on, Hector never rolled across a road without using the crosswalk's \"magic\" correctly.\n\nMoral: Always stop, look both ways, and listen before crossing the street. Use a crosswalk when you can.\n\n\n2. The Red, Yellow, and Green Dragons \nIn the heart of the city lived three magical dragon siblings: Ruby, Yancy, and Gus. They didn't breathe fire; they breathed light! Ruby breathed a bright **Red** light. When she did, everyone and everything had to **STOP**. Cars halted, and pedestrians froze. It was the law. Yancy breathed a glowing **Yellow** light. This light meant \"CAUTION.\" It was a warning that Ruby was about to breathe her red light. It was time to slow down and get ready to stop. Gus breathed a cheerful Green light. When Gus breathed his light, it meant \"GO!\" But only if the way was clear. Cars could drive, and people could cross, but they still had to be careful. One day, Yancy and Gus played a trick. Yancy breathed his yellow light and Gus immediately breathed his green light, without letting Ruby have her turn! The result was chaos. Cars almost crashed into each other, and a family of squirrels got stuck in the middle of the road, terrified. The Great Eagle, the king of the city, swooped down. \"This is why we have an order!\" he scolded. \"Your lights are not a game. They are rules to keep everyone safe. You must work together. The dragon siblings felt ashamed. They learned that their magic was powerful and needed to be used responsibly. They returned to their proper order: Red, Yellow, Green. And the city was safe once more.\n\nMoral: Always obey traffic lights. Red means stop, yellow means slow down/prepare to stop, and green means go (after checking it's safe).\n\n\n3. The Little Fox Who Wore the Dark\n\n Finn the Fox had a beautiful, bushy tail and a new dark blue coat. He loved to play hide-and-seek at dusk, his favorite time of day. One evening, he was chasing fireflies near the road. His dark coat made him almost invisible in the fading light. A car came down the road, and the driver couldn't see Finn at all! Suddenly, a kind badger shined a bright lantern from her porch. \"Finn! Your coat! You blend into the night! The car swerved slightly, and Finn jumped back, his heart pounding. He hadn't realized how dangerous it was.The badger gave Finn a special gift: a small, reflective vest. \"Wear this,\" she said. \"It will reflect the light from the cars, making you shine like a firefly yourself. Then, drivers can see you from far away.\" The next night, Finn put on his new vest. When car headlights hit him, he glowed brightly. The drivers saw him easily and slowed down with a friendly wave. Finn felt safe and visible. He could still play, but now everyone knew where he was.\n\nMoral: When walking in the dark or at dusk, always wear bright or reflective clothing so drivers can see you.\n\n\n4. Sammy Squirrel's Seat Belt Adventure\n\nSammy Squirrel's family was going on a exciting trip to the biggest nut tree in the forest. They all piled into their acorn-shaped car. \"Time to go!\" said Dad, starting the engine. \"Yay!\" cheered Sammy and his sister, bouncing on the soft seats. \"Seat belts,Sammy's sister clicked her seat belt right away. But Sammy thought\", \"It's uncomfortable. I don't need it. We're just driving through the forest!\" He secretly left his belt unbuckled. As the car drove over a bumpy hill, it hit a large stone. The car jolted! Sammy was thrown from his seat and bonked his head on the front seat. \"Oww!\" he cried. Dad stopped the car immediately. \"Oh, Sammy! This is why we wear seat belts. They are like a hug from the car that keeps you safe in your seat if we stop suddenly.\" Sammy rubbed his head and felt foolish. He quickly buckled his seat belt. For the rest of the trip, he felt safe and secure. He realized the seat belt wasn't a restriction; it was a protection.\n\nMoral: Always wear your seat belt when in a car, no matter how short the trip. It keeps you safe.\n\n\n"
