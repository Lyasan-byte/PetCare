//
//  PetActivityCreationViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation
import Combine

final class PetActivityCreationViewModel: PetActivityCreationViewModeling {
    @Published var state: PetActivityCreationState {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()

    private var content: PetActivityCreationContent

    private let ownerId: String
    private let petRepository: PetRepository
    private let activityRepository: PetActivityRepository
    private let moduleOutput: PetActivityCreationModuleOutput?

    init(
        initialActivity: PetActivityType,
        initialSelectedPet: Pet?,
        ownerId: String,
        petRepository: PetRepository,
        activityRepository: PetActivityRepository,
        moduleOutput: PetActivityCreationModuleOutput?
    ) {
        let content = PetActivityCreationContent(
            selectedPet: initialSelectedPet,
            activityId: activityRepository.makeNewActivityId(),
            activity: initialActivity,
            groomingProcedureType: GroomingProcedureType.allCases.first,
            vetProcedureType: VetProcedureType.allCases.first
        )

        self.content = content
        self.state = .content(content)
        self.ownerId = ownerId
        self.petRepository = petRepository
        self.activityRepository = activityRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: PetActivityCreationIntent) {
        if handleSelectionChanges(intent) || handleActivityInputChanges(intent) {
            return
        }

        switch intent {
        case .onDidLoad:
            getPets()
        case .onSave:
            save()
        case .onClose:
            moduleOutput?.moduleWantsToClose()
        case .onDismissAlert:
            state = .content(content)
        default:
            return
        }
    }

    private func handleSelectionChanges(_ intent: PetActivityCreationIntent) -> Bool {
        switch intent {
        case .onChangePet(let pet):
            content.selectedPet = pet
            state = .content(content)
        case .onChangeActivity(let petActivityType):
            content.activity = petActivityType
            state = .content(content)
        case .onChangeDate(let date):
            content.date = date
        case .onChangeNote(let note):
            content.note = note
        default:
            return false
        }

        return true
    }

    private func handleActivityInputChanges(_ intent: PetActivityCreationIntent) -> Bool {
        switch intent {
        case .onSwitchingNotifications(let isOn):
            content.isNotificationsOn = isOn
        case .onChangeWalkGoal(let goalString):
            content.walkGoal = makeDouble(from: goalString)
        case .onChangeWalkActual(let actualString):
            content.walkActual = makeDouble(from: actualString)
        case .onChangeGroomingProcedureType(let procedureType):
            content.groomingProcedureType = procedureType
        case .onChangeGroomingCost(let costString):
            content.groomingCost = makeDouble(from: costString)
        case .onChangeGroomingDuration(let durationString):
            content.groomingDuration = makeDouble(from: durationString)
        case .onChangeVetProcedureType(let procedureType):
            content.vetProcedureType = procedureType
        case .onChangeVetCost(let costString):
            content.vetCost = makeDouble(from: costString)
        default:
            return false
        }

        return true
    }

    private func getPets() {
        state = .loading

        petRepository.fetchPets(for: ownerId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] pets in
                guard let self else { return }

                self.content.pets = pets

                if let selectedPet = self.content.selectedPet {
                    self.content.selectedPet = pets.first { $0.id == selectedPet.id } ?? selectedPet
                } else {
                    self.content.selectedPet = pets.first
                }

                self.state = .content(self.content)
            }
            .store(in: &bag)
    }

    private func save() {
        if let validateError = validate() {
            state = .error(validateError)
            return
        }

        guard let activity = makeActivity() else {
            state = .error("Please fill all the fields correctly")
            return
        }

        state = .loading

        activityRepository.save(activity: activity, activityId: content.activityId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                self?.moduleOutput?.moduleWantsToClose()
            }
            .store(in: &bag)
    }

    private func validate() -> String? {
        guard content.selectedPet != nil else {
            return "Please select a pet"
        }

        switch content.activity {
        case .walk:
            return validateWalk()
        case .grooming:
            return validateGrooming()
        case .vet:
            return validateVet()
        }
    }

    private func validateWalk() -> String? {
        guard let walkGoal = content.walkGoal else {
            return "Please enter goal distance"
        }

        guard walkGoal > 0 else {
            return "Goal distance should be greater than 0"
        }

        guard let walkActual = content.walkActual else {
            return "Please enter actual distance"
        }

        guard walkActual > 0 else {
            return "Actual distance should be greater than 0"
        }

        guard walkActual <= walkGoal else {
            return "Actual distance cannot be greater than goal distance"
        }

        return nil
    }

    private func validateGrooming() -> String? {
        guard let groomingCost = content.groomingCost else {
            return "Please enter grooming cost"
        }

        guard groomingCost >= 0 else {
            return "Grooming cost cannot be negative"
        }

        return nil
    }

    private func validateVet() -> String? {
        guard let vetCost = content.vetCost else {
            return "Please enter vet cost"
        }

        guard vetCost >= 0 else {
            return "Vet cost cannot be negative"
        }

        return nil
    }

    private func makeActivity() -> PetActivity? {
        guard let selectedPet = content.selectedPet,
            let petId = selectedPet.id else {
            return nil
        }

        let details: PetActivityDetails

        switch content.activity {
        case .walk:
            guard let walkGoal = content.walkGoal,
                let walkActual = content.walkActual else {
                return nil
            }

            details = .walk(
                WalkDetails(
                    goal: walkGoal,
                    actual: walkActual
                )
            )

        case .grooming:
            guard let procedureType = content.groomingProcedureType,
                let groomingCost = content.groomingCost,
                let duration = content.groomingDuration else {
                return nil
            }

            details = .grooming(
                GroomingDetails(
                    procedureType: procedureType,
                    cost: groomingCost,
                    duration: duration
                )
            )

        case .vet:
            guard let procedureType = content.vetProcedureType,
                let vetCost = content.vetCost else {
                return nil
            }

            details = .vet(
                VetDetails(
                    procedureType: procedureType,
                    cost: vetCost
                )
            )
        }

        return PetActivity(
            id: content.activityId,
            petId: petId,
            date: content.date,
            isReminder: content.isNotificationsOn,
            note: content.note,
            type: content.activity,
            details: details
        )
    }

    private func makeDouble(from string: String) -> Double? {
        let normalizedString = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        guard !normalizedString.isEmpty else {
            return nil
        }

        return Double(normalizedString)
    }
}
