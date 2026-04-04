import UIKit

final class PetsMainView: UIView {
    var onAddPetButtonTap: (() -> Void)?
    
    private let loader = UIActivityIndicatorView()
    private let emptyStateView = EmptyStateView(
        title: L10n.Pets.Main.EmptyState.title,
        subtitle: L10n.Pets.Main.EmptyState.subtitle,
        image: "pawprint.fill"
    )
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = PetsMainSection(rawValue: sectionIndex) else {
                return nil
            }
            switch section {
            case .top:
                return createTopSection()
            case .pets:
                return createPetsSection()
            }
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        addPetButton.isHidden = isLoading
        collectionView.isHidden = isLoading
    }
    
    func setupCollection(dataSource: UICollectionViewDataSource,
                         delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
    
    func registerCells() {
        collectionView.register(
            PetsMainTopCell.self,
            forCellWithReuseIdentifier: PetsMainTopCell.identifier
        )
        
        collectionView.register(
            PetCardCollectionCell.self,
            forCellWithReuseIdentifier: PetCardCollectionCell.identifier
        )
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true
        loader.style = .medium
        loader.hidesWhenStopped = true
        emptyStateView.isHidden = true
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
        return NSCollectionLayoutSection(group: group)
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
