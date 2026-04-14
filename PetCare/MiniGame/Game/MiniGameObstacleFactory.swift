//
//  MiniGameObstacleFactory.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13/04/26.
//

import SpriteKit

final class MiniGameObstacleFactory {
    private enum ObstacleKind: CaseIterable {
        case largePlant
        case mediumPlant
        case smallPlant
        case smallPair
        case mediumWithSmall
        case longSmallCluster
        case longMixedCluster
    }

    private struct ObstaclePart {
        let texture: SKTexture
        let size: CGSize
        let x: CGFloat
        let bodySize: CGSize
        let bodyCenterYOffset: CGFloat
    }

    private lazy var obstacleTextures: [ObstacleKind: SKTexture] = {
        let largeTexture = SKTexture(image: Asset.miniGamePlantLarge.image)
        let mediumTexture = SKTexture(image: Asset.miniGamePlantMedium.image)
        let smallTexture = SKTexture(image: Asset.miniGamePlantSmall.image)

        [largeTexture, mediumTexture, smallTexture].forEach {
            $0.filteringMode = .nearest
        }

        return [
            .largePlant: largeTexture,
            .mediumPlant: mediumTexture,
            .smallPlant: smallTexture,
            .smallPair: smallTexture,
            .mediumWithSmall: mediumTexture,
            .longSmallCluster: smallTexture,
            .longMixedCluster: mediumTexture
        ]
    }()

    func makeObstacle(
        currentWorldSpeed: CGFloat,
        baseWorldSpeed: CGFloat,
        maxWorldSpeed: CGFloat,
        sceneWidth: CGFloat,
        groundTopY: CGFloat,
        obstacleCategory: UInt32,
        runnerCategory: UInt32
    ) -> SKNode {
        let obstacle = makeObstacleNode(
            kind: nextObstacleKind(
                currentWorldSpeed: currentWorldSpeed,
                baseWorldSpeed: baseWorldSpeed,
                maxWorldSpeed: maxWorldSpeed
            ),
            obstacleCategory: obstacleCategory,
            runnerCategory: runnerCategory
        )
        let obstacleWidth = obstacle.calculateAccumulatedFrame().width
        obstacle.position = CGPoint(
            x: sceneWidth + obstacleWidth / 2 + 24,
            y: groundTopY
        )
        obstacle.zPosition = 2
        obstacle.userData = ["didScore": false]
        return obstacle
    }

    func makeSpawnInterval(
        currentWorldSpeed: CGFloat,
        baseWorldSpeed: CGFloat,
        maxWorldSpeed: CGFloat
    ) -> TimeInterval {
        let speedProgress = min(
            max((currentWorldSpeed - baseWorldSpeed) / (maxWorldSpeed - baseWorldSpeed), 0),
            1
        )
        let minInterval = 1.02 - (0.12 * speedProgress)
        let maxInterval = 1.72 - (0.16 * speedProgress)
        return TimeInterval.random(in: minInterval...maxInterval)
    }

    private func nextObstacleKind(
        currentWorldSpeed: CGFloat,
        baseWorldSpeed: CGFloat,
        maxWorldSpeed: CGFloat
    ) -> ObstacleKind {
        let speedProgress = min(
            max((currentWorldSpeed - baseWorldSpeed) / (maxWorldSpeed - baseWorldSpeed), 0),
            1
        )

        var availableKinds: [ObstacleKind] = [
            .largePlant,
            .mediumPlant,
            .smallPlant,
            .smallPair,
            .mediumWithSmall
        ]

        if speedProgress >= 0.38 {
            availableKinds.append(.longSmallCluster)
        }

        if speedProgress >= 0.62 {
            availableKinds.append(.longMixedCluster)
        }

        return availableKinds.randomElement() ?? .smallPlant
    }

    private func makeObstacleNode(
        kind: ObstacleKind,
        obstacleCategory: UInt32,
        runnerCategory: UInt32
    ) -> SKNode {
        let obstacle = SKNode()
        let parts = obstacleParts(for: kind)

        let bodies = parts.map { part -> SKPhysicsBody in
            let center = CGPoint(x: part.x, y: part.bodyCenterYOffset)
            return SKPhysicsBody(rectangleOf: part.bodySize, center: center)
        }

        for part in parts {
            let sprite = SKSpriteNode(texture: part.texture, size: part.size)
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            sprite.position = CGPoint(x: part.x, y: 0)
            obstacle.addChild(sprite)
        }

        obstacle.physicsBody = SKPhysicsBody(bodies: bodies)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.contactTestBitMask = runnerCategory

        return obstacle
    }

    private func obstacleParts(for kind: ObstacleKind) -> [ObstaclePart] {
        switch kind {
        case .largePlant:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.largePlant] ?? SKTexture(),
                    size: CGSize(width: 144, height: 144),
                    x: 0,
                    bodySize: CGSize(width: 60, height: 38),
                    bodyCenterYOffset: 24
                )
            ]
        case .mediumPlant:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.mediumPlant] ?? SKTexture(),
                    size: CGSize(width: 124, height: 124),
                    x: 0,
                    bodySize: CGSize(width: 52, height: 32),
                    bodyCenterYOffset: 21
                )
            ]
        case .smallPlant:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.smallPlant] ?? SKTexture(),
                    size: CGSize(width: 118, height: 150),
                    x: 0,
                    bodySize: CGSize(width: 46, height: 40),
                    bodyCenterYOffset: 24
                )
            ]
        case .smallPair:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.smallPair] ?? SKTexture(),
                    size: CGSize(width: 94, height: 126),
                    x: -22,
                    bodySize: CGSize(width: 34, height: 34),
                    bodyCenterYOffset: 21
                ),
                ObstaclePart(
                    texture: obstacleTextures[.smallPair] ?? SKTexture(),
                    size: CGSize(width: 94, height: 126),
                    x: 22,
                    bodySize: CGSize(width: 34, height: 34),
                    bodyCenterYOffset: 21
                )
            ]
        case .mediumWithSmall:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.mediumWithSmall] ?? SKTexture(),
                    size: CGSize(width: 116, height: 116),
                    x: -22,
                    bodySize: CGSize(width: 48, height: 30),
                    bodyCenterYOffset: 20
                ),
                ObstaclePart(
                    texture: obstacleTextures[.smallPlant] ?? SKTexture(),
                    size: CGSize(width: 90, height: 120),
                    x: 58,
                    bodySize: CGSize(width: 34, height: 30),
                    bodyCenterYOffset: 19
                )
            ]
        case .longSmallCluster:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.longSmallCluster] ?? SKTexture(),
                    size: CGSize(width: 88, height: 112),
                    x: -72,
                    bodySize: CGSize(width: 32, height: 28),
                    bodyCenterYOffset: 18
                ),
                ObstaclePart(
                    texture: obstacleTextures[.longSmallCluster] ?? SKTexture(),
                    size: CGSize(width: 98, height: 132),
                    x: 0,
                    bodySize: CGSize(width: 36, height: 34),
                    bodyCenterYOffset: 21
                ),
                ObstaclePart(
                    texture: obstacleTextures[.longSmallCluster] ?? SKTexture(),
                    size: CGSize(width: 88, height: 112),
                    x: 72,
                    bodySize: CGSize(width: 32, height: 28),
                    bodyCenterYOffset: 18
                )
            ]
        case .longMixedCluster:
            return [
                ObstaclePart(
                    texture: obstacleTextures[.smallPlant] ?? SKTexture(),
                    size: CGSize(width: 82, height: 104),
                    x: -96,
                    bodySize: CGSize(width: 30, height: 24),
                    bodyCenterYOffset: 16
                ),
                ObstaclePart(
                    texture: obstacleTextures[.longMixedCluster] ?? SKTexture(),
                    size: CGSize(width: 116, height: 116),
                    x: -18,
                    bodySize: CGSize(width: 48, height: 30),
                    bodyCenterYOffset: 20
                ),
                ObstaclePart(
                    texture: obstacleTextures[.smallPlant] ?? SKTexture(),
                    size: CGSize(width: 90, height: 120),
                    x: 74,
                    bodySize: CGSize(width: 34, height: 28),
                    bodyCenterYOffset: 18
                )
            ]
        }
    }
}
