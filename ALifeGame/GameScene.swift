//
//  GameScene.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/23.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate: class {
    func gameSceneDidEnterALifeWorld(_ scene: GameScene)
}

final class GameScene: SKScene {
    weak var gameSceneDelegate: GameSceneDelegate?

    private var cameraNode: SKCameraNode! {
        return childNode(withName: "//camera") as? SKCameraNode
    }

    private var clockLabelNode: SKLabelNode! {
        return childNode(withName: "//clock_label") as? SKLabelNode
    }

    private var versionLabelNode: SKLabelNode! {
        return childNode(withName: "//version_label") as? SKLabelNode
    }

    var focusPoint = FocusPoint.none
    private let cameraDefaultZoomScale: CGFloat = 8.0
    private var isSceneLoaded = false

    override func sceneDidLoad() {
        super.sceneDidLoad()
        isSceneLoaded = true

        clockLabelNode.alpha = 0.0
        versionLabelNode.alpha = 0.0
        versionLabelNode.text = "ver \(Bundle.main.versionFullString)"

        if UserDefaults.standard.anyOnboardingFinished {
            changeFocusPoint(to: .none, forceReload: true)
        } else {
            isUserInteractionEnabled = false

            changeFocusPoint(to: .none, forceReload: true) { [weak self] in
                let nodeName = "paper_01"
                guard let self = self, let onboardingNode = self.childNode(withName: nodeName) else {
                    return
                }
                let nodePosition = self.convert(onboardingNode.position, to: self)
                self.changeFocusPoint(to: .paper(position: nodePosition, nodeName: nodeName), delay: 0.6) { [weak self] in
                    self?.isUserInteractionEnabled = true
                    UserDefaults.standard.anyOnboardingFinished = true
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodes = tappedNodes(of: touches)
        var focusPoint: FocusPoint?

        for node in nodes {
            let nodePosition: CGPoint
            if node.parent == self {
                nodePosition = convert(node.position, to: self)
            } else {
                nodePosition = node.convert(node.position, to: self)    // node.parent == self の状態だと position が倍ずれるため
            }
            switch node.name {
            case "book_shelf":
                focusPoint = .bookShelf(position: nodePosition)
            case "display":
                focusPoint = .display(position: nodePosition)
            case "clock":
                focusPoint = .clock(position: nodePosition)
            case "picture":
                focusPoint = .picture(position: nodePosition)
            case "corkboard":
                focusPoint = .corkboard(position: nodePosition)
            case "paper_01", "paper_02":
                focusPoint = .paper(position: nodePosition, nodeName: node.name!)
            default:
                break
            }
            guard focusPoint == nil else {
                break
            }
        }

        changeFocusPoint(to: focusPoint ?? .none)
    }

    override func update(_ currentTime: TimeInterval) {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        clockLabelNode.text = dateFormatter.string(from: Date())
    }
}

extension GameScene {
    enum FocusPoint {
        case bookShelf(position: CGPoint)
        case display(position: CGPoint)
        case clock(position: CGPoint)
        case picture(position: CGPoint)
        case corkboard(position: CGPoint)
        case paper(position: CGPoint, nodeName: String)
        case none
    }

    private func tappedNodes(of touches: Set<UITouch>) -> [SKNode] {
        guard let touchLocation = touches.first?.location(in: self) else {
            return []
        }
        return nodes(at: touchLocation)
    }

    private func changeFocusPoint(to focusPoint: FocusPoint, forceReload: Bool = false, delay: TimeInterval? = nil, completion block: (() -> Void)? = nil) {
        let previousFocusPoint = self.focusPoint
        guard isSceneLoaded else {
            return
        }
        let isNeeded = forceReload || (focusPoint != previousFocusPoint) || (block != nil)
        guard isNeeded else {
            return
        }
        self.focusPoint = focusPoint

        let defaultDuration: TimeInterval = 0.4

        switch previousFocusPoint {
        case .clock:
            if case .clock = focusPoint {   // guard で書けないか？
                break
            }
            let fadeOutAction = SKAction.fadeOut(withDuration: defaultDuration)
            clockLabelNode.run(fadeOutAction)
            versionLabelNode.run(fadeOutAction)

        default:
            break
        }

        switch focusPoint {
        case .bookShelf(let position):
            let cameraActions: [SKAction] = [
                SKAction.move(to: cameraPositionInScene(position, zoomScale: cameraDefaultZoomScale), duration:defaultDuration)
            ]
            cameraNode.run(SKAction.group(cameraActions), completion: block ?? {})

        case .display(let position):
            let zoomScale: CGFloat = cameraDefaultZoomScale / 6.0
            let cameraActions: [SKAction] = [
                SKAction.move(to: cameraPositionInScene(position, zoomScale: zoomScale), duration:defaultDuration),
                SKAction.scale(to: zoomScale, duration: defaultDuration)
            ]

            cameraNode.run(SKAction.group(cameraActions)) { [weak self] in
                defer {
                    block?()
                }
                guard let self = self else {
                    return
                }
                switch self.focusPoint {
                case .display:
                    self.gameSceneDelegate?.gameSceneDidEnterALifeWorld(self)
                default:
                    break
                }
            }

        case .clock(let position):
            let leftAlignedPosition = position + CGPoint.init(x: 240.0, y: 0.0)
            let zoomScale = cameraDefaultZoomScale / 4.0
            let cameraActions: [SKAction] = [
                SKAction.move(to: cameraPositionInScene(leftAlignedPosition, zoomScale: zoomScale), duration:defaultDuration),
                SKAction.scale(to: zoomScale, duration: defaultDuration),
            ]
            cameraNode.run(SKAction.group(cameraActions), completion: block ?? {})

            let fadeInAction = SKAction.fadeIn(withDuration: defaultDuration)
            clockLabelNode.run(fadeInAction)
            versionLabelNode.run(fadeInAction)

        case .picture(let position):
            let zoomScale = cameraDefaultZoomScale / 2.0
            let cameraActions: [SKAction] = [
                SKAction.move(to: cameraPositionInScene(position, zoomScale: zoomScale), duration:defaultDuration),
                SKAction.scale(to: zoomScale, duration: defaultDuration)
            ]
            cameraNode.run(SKAction.group(cameraActions), completion: block ?? {})

        case .corkboard(let position):
            let zoomScale = cameraDefaultZoomScale / 2.2
            let cameraActions: [SKAction] = [
                SKAction.move(to: cameraPositionInScene(position, zoomScale: zoomScale), duration:defaultDuration),
                SKAction.scale(to: zoomScale, duration: defaultDuration)
            ]
            cameraNode.run(SKAction.group(cameraActions), completion: block ?? {})

        case .paper(let position, let nodeName):
            let zoomScale = cameraDefaultZoomScale / 5.0
            let actionGroup = SKAction.group([
                SKAction.move(to: cameraPositionInScene(position, zoomScale: zoomScale), duration:defaultDuration),
                SKAction.scale(to: zoomScale, duration: defaultDuration)
            ])
            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: delay ?? 0.0),
                actionGroup
            ])
            cameraNode.run(actionSequence, completion: block ?? {})

            brindPaperToFront(nodeName: nodeName)

        case .none:
            let cameraActions: [SKAction] = [
                SKAction.move(to: cameraPositionInScene(.zero, zoomScale: cameraDefaultZoomScale), duration:defaultDuration),
                SKAction.scale(to: cameraDefaultZoomScale, duration: defaultDuration)
            ]
            cameraNode.run(SKAction.group(cameraActions), completion: block ?? {})
        }
    }

    private func cameraPositionInScene(_ position: CGPoint, zoomScale: CGFloat) -> CGPoint {
        let calibratedZoomScale = cameraDefaultZoomScale / zoomScale
        let sceneBounds = CGSize.init(width: 5336.0, height: 1500.0)         // TODO: 動的に求める
        let cameraBounds = CGSize.init(width: (sceneBounds.width / 2.0) / calibratedZoomScale, height: sceneBounds.height / calibratedZoomScale)  // TODO: 動的に求める

        let maxX = (sceneBounds.width / 2.0) - (cameraBounds.width / 2.0)
        let maxY = (sceneBounds.height / 2.0) - (cameraBounds.height / 2.0)

        let cameraMaxPosition = CGPoint.init(x: maxX, y: maxY)
        let cameraMinPosition = CGPoint.zero - cameraMaxPosition

        let positionInScene = max(cameraMinPosition, min(cameraMaxPosition, position))

        return positionInScene
    }

    private func brindPaperToFront(nodeName: String) {
        var nodeNames: Set<String> = [
            "paper_01",
            "paper_02"
        ]
        nodeNames.remove(nodeName)
        guard let otherNodeName = nodeNames.first else {
            return
        }
        guard let nodeToBeFront = childNode(withName: nodeName), let nodeToBeBack = childNode(withName: otherNodeName) else {
            return
        }

        let frontZPosition: CGFloat = 20.0
        let backZPosition: CGFloat = 10.0

        nodeToBeFront.zPosition = frontZPosition
        nodeToBeBack.zPosition = backZPosition
    }
}

extension GameScene.FocusPoint: Equatable { // associated value が Equatable の Enum は勝手に Equatable になるのか？
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .bookShelf(let lPosition):
            if case .bookShelf(let rPosition) = rhs {
                return lPosition == rPosition
            } else {
                return false
            }

        case .display(let lPosition):
            if case .display(let rPosition) = rhs {
                return lPosition == rPosition
            } else {
                return false
            }

        case .clock(let lPosition):
            if case .clock(let rPosition) = rhs {
                return lPosition == rPosition
            } else {
                return false
            }

        case .picture(let lPosition):
            if case .picture(let rPosition) = rhs {
                return lPosition == rPosition
            } else {
                return false
            }

        case .corkboard(let lPosition):
            if case .corkboard(let rPosition) = rhs {
                return lPosition == rPosition
            } else {
                return false
            }

        case .paper(let lPosition):
            if case .paper(let rPosition) = rhs {
                return lPosition == rPosition
            } else {
                return false
            }

        case .none:
            if case .none = rhs {
                return true
            } else {
                return false
            }
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func *(size: CGPoint, constant: CGFloat) -> CGPoint {
        return CGPoint.init(x: size.x * constant, y: size.y * constant)
    }

    static func /(size: CGPoint, constant: CGFloat) -> CGPoint {
        return CGPoint.init(x: size.x / constant, y: size.y / constant)
    }
}

func max(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
    return CGPoint.init(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y))
}

func min(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
    return CGPoint.init(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y))
}
