//
//  PetActivityCreationView.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import UIKit

final class PetActivityCreationView: UIView {
    var onWalkGoalChange: ((String) -> Void)?
    var onWalkActualChange: ((String) -> Void)?

    var onGroomingProcedureChange: ((Int) -> Void)?
    var onGroomingCostChange: ((String) -> Void)?
    var onGroomingDurationChange: ((String) -> Void)?

    var onVetProcedureChange: ((Int) -> Void)?
    var onVetCostChange: ((String) -> Void)?

    private let loader = UIActivityIndicatorView()
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        view.isHidden = true
        return view
    }()
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let scrollView = ScrollView()

    private lazy var activityDetailsContainer = VStack(
        arrangedSubviews: [
            walkDetails,
            groomingDetails,
            vetDetails
        ]
    )

    private lazy var scrollContent = VStack(
        spacing: 16,
        arrangedSubviews: [
            petSelectionCollection,
            activityPicker,
            datePicker,
            activityDetailsContainer,
            noteTextField,
            notificationsSwitch,
            saveButton
        ]
    )

    private lazy var keyboardDismissTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        return gesture
    }()

    let petSelectionCollection = PetActivityCreationCollectionView()
    let activityPicker = SegmentedPickerView(
        items: PetActivityType.allCases.map(\.name)
    )

    let datePicker = DatePickerView(title: L10n.Pets.Activity.date)
    let noteTextField = NoteTextView(title: L10n.Pets.Activity.notes)
    let notificationsSwitch = SwitchOptionView(
        title: L10n.Pets.Activity.Reminder.title,
        subtitle: L10n.Pets.Activity.Reminder.subtitle,
        symbolName: "bell.fill",
        iconColor: Asset.purpleAccent.color,
        circleColor: Asset.petPurpleAction.color,
        circleSize: 45,
        iconSize: 20
    )

    let walkDetails = WalkCreationView()
    let groomingDetails = GroomingCreationView()
    let vetDetails = VetCreationView()
    let saveButton = PrimaryButton(title: L10n.Pets.Activity.saveButton)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
        bindActions()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(background)
        background.addSubview(scrollContent)

        addSubview(loadingOverlay)
        loadingOverlay.addSubview(loader)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            background.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            background.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            background.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            scrollContent.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            scrollContent.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            scrollContent.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            scrollContent.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),

            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor),

            petSelectionCollection.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    func setLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }

        loader.isHidden = !isLoading
        scrollView.isUserInteractionEnabled = !isLoading
    }

    func setupCollection(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate
    ) {
        petSelectionCollection.setupCollection(
            dataSource: dataSource,
            delegate: delegate
        )
        petSelectionCollection.registerCell()
    }

    func reloadData() {
        petSelectionCollection.reloadData()
    }

    func setData(
        selectedPet: Pet?,
        selectedActivity: PetActivityType = .walk,
        isNotificationsOn: Bool
    ) {
        let index = PetActivityType.allCases.firstIndex(of: selectedActivity) ?? 0
        activityPicker.setSelectedIndex(index)

        walkDetails.isHidden = selectedActivity != .walk
        groomingDetails.isHidden = selectedActivity != .grooming
        vetDetails.isHidden = selectedActivity != .vet
        notificationsSwitch.subtitleLabel.text = selectedActivity.reminderSubtitle
        notificationsSwitch.switchControl.setOn(isNotificationsOn, animated: window != nil)
    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false

        loader.style = .medium
        loader.hidesWhenStopped = true
        addGestureRecognizer(keyboardDismissTapGesture)
    }

    private func bindActions() {
        walkDetails.onDistanceChange = { [weak self] distance in
            self?.onWalkGoalChange?(distance)
        }

        walkDetails.onActualDistanceChange = { [weak self] actualDistance in
            self?.onWalkActualChange?(actualDistance)
        }

        groomingDetails.onChangeProcedure = { [weak self] index in
            self?.onGroomingProcedureChange?(index)
        }

        groomingDetails.onCostChange = { [weak self] cost in
            self?.onGroomingCostChange?(cost)
        }
        
        groomingDetails.onDurationChange = { [weak self] duration in
            self?.onGroomingDurationChange?(duration)
        }

        vetDetails.onChangeProcedure = { [weak self] index in
            self?.onVetProcedureChange?(index)
        }

        vetDetails.onCostChange = { [weak self] cost in
            self?.onVetCostChange?(cost)
        }
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
