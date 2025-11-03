

import UIKit
import SnapKit

final class SelectCell: UICollectionViewCell {
    
    let viewModel = BaseViewModel.shared

    private let previewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
        setupeConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(_ data: PuzzleImagesData) {
        previewImage.image = data.preview
    }
}
private extension SelectCell {
    func initialization() {
        contentView.addSubview(previewImage)
    }
    func setupeConstraint() {
        previewImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
