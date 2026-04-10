//
//  MiniGameViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Foundation
import Combine

final class MiniGameViewModel: MiniGameViewModeling {
    @Published private(set) var state: MiniGameState = .loading {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()

    private let petRepository: PetRepository
    private let bestScoreRepository: MiniGameBestScoreRepository
    private weak var moduleOutput: MiniGameModuleOutput?
    private let ownerId: String

    private var bag = Set<AnyCancellable>()
    private var content = MiniGameContent()
    private var previewFinishTask: Task<Void, Never>?

    init(
        petRepository: PetRepository,
        bestScoreRepository: MiniGameBestScoreRepository,
        ownerId: String,
        moduleOutput: MiniGameModuleOutput?
    ) {
        self.petRepository = petRepository
        self.bestScoreRepository = bestScoreRepository
        self.ownerId = ownerId
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: MiniGameIntent) {
        switch intent {
        case .onDidLoad:
            fetchPets()
        case .onPetSelected(let pet):
            selectPet(pet)
        case .onGameFieldTap:
            guard !content.isEmpty, content.selectedPet != nil else { return }

            switch content.stage {
            case .idle, .finished:
                startPreview()
            case .started:
                break
            }
        case .onPreviewFinished:
            finishPreview()
        case .onRestartTap:
            resetToIdle()
        case .onDismissAlert:
            state = .content(content)
        }
    }

    private func fetchPets() {
        state = .loading

        petRepository.fetchPets(for: ownerId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] pets in
                guard let self else { return }

                cancelPreviewFinish()
                content.pets = pets
                content.currentScore = 0
                content.lastRunScore = 0
                content.stage = .idle

                if let selectedPet = content.selectedPet,
                    pets.contains(where: { $0.miniGameRunnerKey == selectedPet.miniGameRunnerKey }) {
                    content.selectedPetKey = selectedPet.miniGameRunnerKey
                } else {
                    content.selectedPetKey = pets.first?.miniGameRunnerKey
                }

                refreshBestScore()
                state = .content(content)
            }
            .store(in: &bag)
    }

    private func selectPet(_ pet: Pet) {
        guard content.selectedPet?.miniGameRunnerKey != pet.miniGameRunnerKey else { return }

        cancelPreviewFinish()
        content.selectedPetKey = pet.miniGameRunnerKey
        content.currentScore = 0
        content.lastRunScore = 0
        content.stage = .idle
        refreshBestScore()
        state = .content(content)
    }

    private func startPreview() {
        cancelPreviewFinish()
        content.currentScore = 0
        content.lastRunScore = 0
        content.stage = .started
        state = .content(content)
        schedulePreviewFinish()
    }

    private func finishPreview() {
        guard content.stage == .started else { return }

        let score = 0
        content.currentScore = score
        content.lastRunScore = score

        if let selectedPet = content.selectedPet {
            let newBestScore = max(bestScoreRepository.bestScore(for: selectedPet), score)
            content.bestScore = newBestScore
            bestScoreRepository.saveBestScore(newBestScore, for: selectedPet)
        } else {
            content.bestScore = 0
        }

        content.stage = .finished
        state = .content(content)
    }

    private func resetToIdle() {
        cancelPreviewFinish()
        content.currentScore = 0
        content.lastRunScore = 0
        content.stage = .idle
        refreshBestScore()
        state = .content(content)
    }

    private func refreshBestScore() {
        guard let selectedPet = content.selectedPet else {
            content.bestScore = 0
            return
        }

        content.bestScore = bestScoreRepository.bestScore(for: selectedPet)
    }

    private func schedulePreviewFinish() {
        previewFinishTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(1.2))
            guard !Task.isCancelled else { return }
            self?.trigger(.onPreviewFinished)
        }
    }

    private func cancelPreviewFinish() {
        previewFinishTask?.cancel()
        previewFinishTask = nil
    }
}
