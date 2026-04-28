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
            startGame()
        case .onGameScoreUpdated(let score):
            updateCurrentScore(score)
        case .onGameEnded(let score):
            finishGame(with: score)
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

        content.selectedPetKey = pet.miniGameRunnerKey
        content.currentScore = 0
        content.lastRunScore = 0
        content.stage = .idle
        refreshBestScore()
        state = .content(content)
    }

    private func startGame() {
        guard !content.isEmpty, content.selectedPet != nil else { return }

        content.currentScore = 0
        content.lastRunScore = 0
        content.stage = .started
        state = .content(content)
    }

    private func updateCurrentScore(_ score: Int) {
        guard content.stage == .started, content.currentScore != score else { return }

        content.currentScore = score
        state = .content(content)
    }

    private func finishGame(with score: Int) {
        guard content.stage == .started else { return }

        content.currentScore = score
        content.lastRunScore = score

        if let selectedPet = content.selectedPet {
            let newBestScore = max(bestScoreRepository.bestScore(for: selectedPet), score)
            content.bestScore = newBestScore
            bestScoreRepository.saveBestScore(newBestScore, for: selectedPet)
            saveBestScoreIfNeeded(
                newBestScore,
                currentRemoteScore: selectedPet.gameScore,
                petId: selectedPet.id
            )
        } else {
            content.bestScore = 0
        }

        content.stage = .finished
        state = .content(content)
    }

    private func resetToIdle() {
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

    private func saveBestScoreIfNeeded(_ bestScore: Int, currentRemoteScore: Int, petId: String?) {
        guard bestScore > currentRemoteScore, let petId else { return }

        petRepository.updateGameScore(bestScore, for: petId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    state = .error(error.localizedDescription)
                }
            } receiveValue: { _ in
            }
            .store(in: &bag)
    }
}
