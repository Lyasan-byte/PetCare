import UIKit

final class PetsMainView: UIView {
    var onAddPetButtonTap: (() -> Void)?
    
    private let loader = UIActivityIndicatorView()
    private let emptyStateView = EmptyStateView(
        title: L10n.Pets.Main.EmptyState.title,
        subtitle: L10n.Pets.Main.EmptyState.subtitle,
        image: "pawprint"
    )
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                return createTopSection()
            } else {
                return createPetsSection()
            }
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let addPetButton = CircleIconView(
        symbolName: "plus",
        iconColor: .white,
        circleColor: Asset.primaryGreen.color,
        circleSize: 52,
        iconSize: 18,
        weight: .medium,
        shadowColor: Asset.accentColor.color
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
        setupAction()
    }
    
    private func setupHierarchy() {
        addSubview(collectionView)
        addSubview(loader)
        addSubview(emptyStateView)
        addSubview(addPetButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            addPetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addPetButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func showEmptyStateView(_ isShown: Bool) {
        emptyStateView.isHidden = !isShown
        collectionView.isHidden = isShown
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        
        loader.isHidden = !isLoading
        collectionView.isHidden = isLoading
        addPetButton.isHidden = isLoading
        emptyStateView.isHidden = true
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true
        loader.style = .medium
        loader.hidesWhenStopped = true
    }
    
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didAddPetButtonTap))
        addPetButton.addGestureRecognizer(tap)
        addPetButton.isUserInteractionEnabled = true
    }
    
    @objc private func didAddPetButtonTap() {
        onAddPetButtonTap?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetsMainView {
    private static func createTopSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(320)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(320)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createPetsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 16, bottom: 0, trailing: 16)
        return section
    }
}
