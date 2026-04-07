//
//  UserProfileEditViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import Combine

final class UserProfileEditViewModel: UserProfileEditViewModeling {
    @Published private(set) var state: UserProfileEditState {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()
    private let userProfileRepository: UserProfileRepository
    private weak var moduleOutput: UserProfileEditModuleOutput?
    private var bag = Set<AnyCancellable>()
    private var displayData: UserProfileEditDisplayData

    init(
        user: UserProfileUser,
        userProfileRepository: UserProfileRepository,
        moduleOutput: UserProfileEditModuleOutput?
    ) {
        let initialDisplayData = UserProfileEditDisplayData(user: user)
        self.state = .content(initialDisplayData)
        self.displayData = initialDisplayData
        self.userProfileRepository = userProfileRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: UserProfileEditIntent) {
        switch intent {
        case .onChangeFirstName(let firstName):
            displayData.firstName = firstName
            state = .content(displayData)
        case .onChangeLastName(let lastName):
            displayData.lastName = lastName
            state = .content(displayData)
        case .onPickPhoto(let data):
            displayData.selectedPhotoData = data
            state = .content(displayData)
        case .onSave:
            save()
        case .onDismissAlert:
            state = .content(displayData)
        }
    }

    private func validateForm() -> String? {
        if displayData.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSLocalizedString("user.profile.edit.validation.first_name", comment: "")
        }

        if displayData.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSLocalizedString("user.profile.edit.validation.last_name", comment: "")
        }

        return nil
    }

    private func save() {
        if let validationError = validateForm() {
            state = .error(validationError)
            return
        }

        displayData.isSaving = true
        state = .content(displayData)

        userProfileRepository
            .save(user: makeUpdatedUser(), selectedPhoto: displayData.selectedPhotoData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.displayData.isSaving = false

                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] savedUser in
                guard let self else { return }
                self.displayData.existingPhotoUrl = savedUser.avatarURLString
                self.displayData.selectedPhotoData = nil
                self.state = .content(self.displayData)
                self.moduleOutput?.userProfileEditModuleDidSave()
            }
            .store(in: &bag)
    }

    private func makeUpdatedUser() -> UserProfileUser {
        UserProfileUser(
            id: displayData.userId,
            firstName: displayData.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: displayData.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: displayData.email,
            avatarURLString: displayData.existingPhotoUrl
        )
    }
}
