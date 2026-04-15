//
//  MiniGameScene.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 12/04/26.
//

import SpriteKit
import UIKit

final class MiniGameScene: SKScene, SKPhysicsContactDelegate {
    private enum PhysicsCategory {
        static let runner: UInt32 = 1 << 0
        static let obstacle: UInt32 = 1 << 1
        static let ground: UInt32 = 1 << 2
    }

    weak var output: MiniGameSceneOutput?

    private let runnerImage: UIImage
    private let runnerSize = CGSize(width: 74, height: 74)
    private let groundHeight: CGFloat = 18
    private let groundOffset: CGFloat = 56
    private let baseWorldSpeed: CGFloat = 230
    private let maxWorldSpeed: CGFloat = 420
    private let speedIncreasePerSecond: CGFloat = 8
    private let jumpImpulse: CGFloat = 200
    private let jumpBufferDuration: TimeInterval = 0.14
    private let coyoteTimeDuration: TimeInterval = 0.1
    private let shadowBaseSize = CGSize(width: 52, height: 16)

    private var shadowNode = SKShapeNode()
    private var runnerNode = SKSpriteNode()
    private var groundNodes: [SKSpriteNode] = []
    private var obstacleNodes: [SKNode] = []

    private var lastUpdateTime: TimeInterval = 0
    private var spawnAccumulator: TimeInterval = 0
    private var nextSpawnInterval: TimeInterval = 1.35
    private var currentWorldSpeed: CGFloat = 230
    private var currentScore = 0
    private var isGameOver = false
    private var groundContactCount = 0
    private var lastGroundedTime: TimeInterval = 0
    private var pendingJumpRequestTime: TimeInterval?
    private var wasRunnerGrounded = true
    private let obstacleFactory = MiniGameObstacleFactory()

    init(size: CGSize, runnerImage: UIImage) {
        self.runnerImage = runnerImage
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupScene()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        guard !groundNodes.isEmpty else { return }
        layoutGround()
        layoutRunnerIfNeeded()
    }

    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }

        let deltaTime: TimeInterval
        if lastUpdateTime == 0 {
            deltaTime = 0
        } else {
            deltaTime = min(currentTime - lastUpdateTime, 1.0 / 30.0)
        }
        lastUpdateTime = currentTime

        currentWorldSpeed = min(
            maxWorldSpeed,
            currentWorldSpeed + speedIncreasePerSecond * deltaTime
        )

        moveGround(deltaTime: deltaTime)
        moveObstacles(deltaTime: deltaTime)
        consumeBufferedJumpIfNeeded(at: currentTime)
        updateRunnerPresentation(at: currentTime)
        spawnAccumulator += deltaTime

        if spawnAccumulator >= nextSpawnInterval {
            spawnAccumulator = 0
            nextSpawnInterval = obstacleFactory.makeSpawnInterval(
                currentWorldSpeed: currentWorldSpeed,
                baseWorldSpeed: baseWorldSpeed,
                maxWorldSpeed: maxWorldSpeed
            )
            spawnObstacle()
        }
    }

    func jump() {
        guard !isGameOver else { return }

        pendingJumpRequestTime = max(lastUpdateTime, CACurrentMediaTime())
        consumeBufferedJumpIfNeeded(at: pendingJumpRequestTime ?? lastUpdateTime)
    }

    func stop() {
        isGameOver = true
        removeAllActions()
        obstacleNodes.forEach { $0.removeAllActions() }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == (PhysicsCategory.runner | PhysicsCategory.obstacle) {
            endGame()
            return
        }

        if collision == (PhysicsCategory.runner | PhysicsCategory.ground) {
            groundContactCount += 1
            lastGroundedTime = max(lastUpdateTime, CACurrentMediaTime())
            consumeBufferedJumpIfNeeded(at: lastGroundedTime)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        guard collision == (PhysicsCategory.runner | PhysicsCategory.ground) else { return }

        groundContactCount = max(groundContactCount - 1, 0)
        if groundContactCount > 0 {
            lastGroundedTime = max(lastUpdateTime, CACurrentMediaTime())
        }
    }

    private func setupScene() {
        removeAllChildren()
        obstacleNodes.removeAll()
        groundNodes.removeAll()

        isGameOver = false
        lastUpdateTime = 0
        spawnAccumulator = 0
        currentWorldSpeed = baseWorldSpeed
        currentScore = 0
        groundContactCount = 0
        lastGroundedTime = 0
        pendingJumpRequestTime = nil
        wasRunnerGrounded = true
        nextSpawnInterval = obstacleFactory.makeSpawnInterval(
            currentWorldSpeed: currentWorldSpeed,
            baseWorldSpeed: baseWorldSpeed,
            maxWorldSpeed: maxWorldSpeed
        )

        physicsWorld.gravity = CGVector(dx: 0, dy: -14.45)
        physicsWorld.contactDelegate = self

        createGround()
        createRunner()
    }

    private func createGround() {
        let groundSize = CGSize(width: size.width + 120, height: groundHeight)

        for index in 0..<2 {
            let ground = SKSpriteNode(color: .clear, size: groundSize)
            ground.anchorPoint = CGPoint(x: 0, y: 0.5)
            ground.position = CGPoint(
                x: CGFloat(index) * groundSize.width,
                y: groundCenterY
            )
            ground.physicsBody = SKPhysicsBody(rectangleOf: groundSize)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
            ground.physicsBody?.collisionBitMask = PhysicsCategory.runner
            ground.physicsBody?.contactTestBitMask = PhysicsCategory.runner
            addChild(ground)
            groundNodes.append(ground)
        }
    }

    private func createRunner() {
        shadowNode = SKShapeNode(ellipseOf: shadowBaseSize)
        shadowNode.fillColor = UIColor.black.withAlphaComponent(0.18)
        shadowNode.strokeColor = .clear
        shadowNode.position = CGPoint(x: size.width * 0.22, y: groundTopY + 5)
        shadowNode.zPosition = 1
        addChild(shadowNode)

        let texture = SKTexture(image: runnerImage.circularMiniGameAvatar(size: runnerSize))
        texture.filteringMode = .linear
        runnerNode = SKSpriteNode(texture: texture, size: runnerSize)
        runnerNode.position = CGPoint(x: size.width * 0.22, y: runnerRestY)
        runnerNode.zPosition = 3
        runnerNode.physicsBody = SKPhysicsBody(circleOfRadius: runnerSize.width / 2)
        runnerNode.physicsBody?.allowsRotation = false
        runnerNode.physicsBody?.restitution = 0
        runnerNode.physicsBody?.linearDamping = 0.2
        runnerNode.physicsBody?.categoryBitMask = PhysicsCategory.runner
        runnerNode.physicsBody?.collisionBitMask = PhysicsCategory.ground
        runnerNode.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground
        addChild(runnerNode)

        performIntroBounce()
    }

    private func layoutGround() {
        let groundWidth = size.width + 120
        for (index, groundNode) in groundNodes.enumerated() {
            groundNode.size.width = groundWidth
            groundNode.position = CGPoint(
                x: CGFloat(index) * groundWidth,
                y: groundCenterY
            )
            groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundWidth, height: groundHeight))
            groundNode.physicsBody?.isDynamic = false
            groundNode.physicsBody?.categoryBitMask = PhysicsCategory.ground
            groundNode.physicsBody?.collisionBitMask = PhysicsCategory.runner
            groundNode.physicsBody?.contactTestBitMask = PhysicsCategory.runner
        }
    }

    private func layoutRunnerIfNeeded() {
        guard !isGameOver else { return }
        runnerNode.position = CGPoint(x: size.width * 0.22, y: max(runnerNode.position.y, runnerRestY))
        shadowNode.position.x = runnerNode.position.x
    }

    private func moveGround(deltaTime: TimeInterval) {
        let distance = currentWorldSpeed * deltaTime

        for groundNode in groundNodes {
            groundNode.position.x -= distance
        }

        let groundWidth = groundNodes.first?.size.width ?? 0
        for groundNode in groundNodes where groundNode.position.x + groundWidth < 0 {
            if let maxX = groundNodes.map(\.position.x).max() {
                groundNode.position.x = maxX + groundWidth
            }
        }
    }

    private func moveObstacles(deltaTime: TimeInterval) {
        let distance = currentWorldSpeed * deltaTime

        for obstacle in obstacleNodes {
            obstacle.position.x -= distance
        }

        for obstacle in obstacleNodes {
            updateScoreIfNeeded(for: obstacle)
        }

        obstacleNodes.removeAll { obstacle in
            let shouldRemove = obstacle.position.x < -80
            if shouldRemove {
                obstacle.removeFromParent()
            }
            return shouldRemove
        }
    }

    private func spawnObstacle() {
        let obstacle = obstacleFactory.makeObstacle(
            currentWorldSpeed: currentWorldSpeed,
            baseWorldSpeed: baseWorldSpeed,
            maxWorldSpeed: maxWorldSpeed,
            sceneWidth: size.width,
            groundTopY: groundTopY,
            obstacleCategory: PhysicsCategory.obstacle,
            runnerCategory: PhysicsCategory.runner
        )
        addChild(obstacle)
        obstacleNodes.append(obstacle)
    }

    private func updateScoreIfNeeded(for obstacle: SKNode) {
        guard obstacle.userData?["didScore"] as? Bool != true else { return }
        guard obstacle.frame.maxX < runnerNode.frame.minX else { return }

        obstacle.userData?["didScore"] = true
        currentScore += 1
        output?.miniGameSceneDidUpdateScore(currentScore)
    }

    private func consumeBufferedJumpIfNeeded(at currentTime: TimeInterval) {
        guard let pendingJumpRequestTime else { return }
        guard currentTime - pendingJumpRequestTime <= jumpBufferDuration else {
            self.pendingJumpRequestTime = nil
            return
        }
        guard isRunnerGrounded(at: currentTime) else { return }

        self.pendingJumpRequestTime = nil
        runnerNode.physicsBody?.velocity.dy = 0
        runnerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpImpulse))
        groundContactCount = 0
        wasRunnerGrounded = false
        animateJumpLaunch()
    }

    private func endGame() {
        guard !isGameOver else { return }

        isGameOver = true
        runnerNode.physicsBody?.velocity = .zero
        runnerNode.physicsBody?.affectedByGravity = false
        output?.miniGameSceneDidEndGame(score: currentScore)
    }

    private func isRunnerGrounded(at currentTime: TimeInterval) -> Bool {
        if groundContactCount > 0 {
            return true
        }

        let velocity = runnerNode.physicsBody?.velocity.dy ?? 0
        let isNearGround = abs(velocity) < 30 && runnerNode.position.y <= runnerRestY + 10
        let isWithinCoyoteWindow = currentTime - lastGroundedTime <= coyoteTimeDuration
        return isNearGround || isWithinCoyoteWindow
    }

    private var groundCenterY: CGFloat {
        groundOffset + groundHeight / 2
    }

    private var groundTopY: CGFloat {
        groundOffset + groundHeight
    }

    private var runnerRestY: CGFloat {
        groundTopY + runnerSize.height / 2
    }
}

private extension MiniGameScene {
    func updateRunnerPresentation(at currentTime: TimeInterval) {
        let isGrounded = isRunnerGrounded(at: currentTime)
        if isGrounded, !wasRunnerGrounded {
            animateLanding()
        }
        wasRunnerGrounded = isGrounded

        let velocity = runnerNode.physicsBody?.velocity.dy ?? 0
        let targetRotation: CGFloat
        if isGrounded {
            targetRotation = 0
        } else {
            targetRotation = max(min(velocity / 1200, 0.22), -0.22)
        }
        runnerNode.zRotation += (targetRotation - runnerNode.zRotation) * 0.18

        updateShadow()
    }

    func updateShadow() {
        let heightAboveGround = max(runnerNode.position.y - runnerRestY, 0)
        let progress = min(heightAboveGround / 180, 1)
        let xScale = 1 - (0.34 * progress)
        let yScale = 1 - (0.5 * progress)

        shadowNode.position = CGPoint(x: runnerNode.position.x, y: groundTopY + 5)
        shadowNode.xScale = xScale
        shadowNode.yScale = yScale
        shadowNode.alpha = 0.18 - (0.12 * progress)
    }

    func performIntroBounce() {
        runnerNode.removeAction(forKey: "runnerIntroBounce")
        let intro = SKAction.sequence([
            .group([
                .scaleX(to: 1.05, duration: 0.12),
                .scaleY(to: 0.95, duration: 0.12)
            ]),
            .group([
                .scaleX(to: 0.98, duration: 0.12),
                .scaleY(to: 1.03, duration: 0.12)
            ]),
            .group([
                .scaleX(to: 1.0, duration: 0.16),
                .scaleY(to: 1.0, duration: 0.16)
            ])
        ])
        runnerNode.run(intro, withKey: "runnerIntroBounce")
    }

    func animateJumpLaunch() {
        runnerNode.removeAction(forKey: "runnerJumpSquash")
        let jumpAnimation = SKAction.sequence([
            .group([
                .scaleX(to: 0.92, duration: 0.08),
                .scaleY(to: 1.08, duration: 0.08)
            ]),
            .group([
                .scaleX(to: 1.01, duration: 0.14),
                .scaleY(to: 0.99, duration: 0.14)
            ]),
            .group([
                .scaleX(to: 1.0, duration: 0.1),
                .scaleY(to: 1.0, duration: 0.1)
            ])
        ])
        runnerNode.run(jumpAnimation, withKey: "runnerJumpSquash")
    }

    func animateLanding() {
        runnerNode.removeAction(forKey: "runnerLandingBounce")
        let landingAnimation = SKAction.sequence([
            .group([
                .scaleX(to: 1.11, duration: 0.08),
                .scaleY(to: 0.88, duration: 0.08)
            ]),
            .group([
                .scaleX(to: 0.97, duration: 0.12),
                .scaleY(to: 1.04, duration: 0.12)
            ]),
            .group([
                .scaleX(to: 1.0, duration: 0.12),
                .scaleY(to: 1.0, duration: 0.12)
            ])
        ])
        runnerNode.run(landingAnimation, withKey: "runnerLandingBounce")
    }
}
