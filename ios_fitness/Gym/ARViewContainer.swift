//
//  ARViewContainer.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import Foundation

#if arch(arm64)

import SwiftUI
import RealityKit
import ARKit
import Combine

public protocol PoseDelegate : NSObjectProtocol {
    func counting(count: Int)
}

protocol Action {
    var count: Int { get }
    
    func cleanCount()
    func counting(json: PoseKit.json_BodyPositions)
}

enum ActionEnum {
    case JumpAction
    case CrouchAction
}

// 開合跳
class JumpAction: Action {
    let delegate: PoseDelegate
    var count: Int = 0
    var leftUp = false
    var leftDown = false
    var rightUp = false
    var rightDown = false
    
    init(delegate: PoseDelegate) {
        self.delegate = delegate
    }
    
    func cleanCount() {
        count = 0
    }
    
    func counting(json: PoseKit.json_BodyPositions) {
        switch json.position_leftArm.position { // 左手臂
            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
                leftUp = true
            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue, ShoulderToForearmSubcase.verticalUpParallel.rawValue:
                leftDown = true
        default:
            break
        }

        switch json.position_rightArm.position { // 右手臂
            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
                rightUp = true
            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue, ShoulderToForearmSubcase.verticalUpParallel.rawValue:
                rightDown = true
        default:
            break
        }

        if leftUp && leftDown && rightUp && rightDown {
            leftUp = false
            leftDown = false
            rightUp = false
            rightDown = false
            count += 1
            
            delegate.counting(count: count)
        }
    }
}

// 蹲伏
class CrouchAction: Action {
    let delegate: PoseDelegate
    var count: Int = 0
    var up = false
    var down = false
    
    init(delegate: PoseDelegate) {
        self.delegate = delegate
    }
    
    func cleanCount() {
        count = 0
    }
    
    func counting(json: PoseKit.json_BodyPositions) {
        if json.position_leftArm.position == ShoulderToForearmSubcase.horizontalTransverse.rawValue && json.position_rightArm.position == ShoulderToForearmSubcase.horizontalTransverse.rawValue {
            
            if json.position_leftLeg.position == LegToKneeSubcase.straightParallel.rawValue && json.position_rightLeg.position == LegToKneeSubcase.straightParallel.rawValue {
                up = true
            }
            else if json.position_leftLeg.position == LegToKneeSubcase.openTransversal.rawValue && json.position_rightLeg.position == LegToKneeSubcase.openTransversal.rawValue {
                down = true
            }
            
            if up && down {
                up = false
                down = false
                count += 1
                delegate.counting(count: count)
            }
        }
    }
    
}

class MyARView : ARView, ARSessionDelegate {
    // The 3D character to display.
    var theCharacter: BodyTrackedEntity?
    private let theCharacterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
    let theCharacterAnchor = AnchorEntity()
    private let posekit = PoseKit()
    private let decoder = JSONDecoder()
    
    var handDelegate: PoseDelegate
    var actionEnum: ActionEnum
    var action: Action
    
    init(frame: CGRect, handDelegate: PoseDelegate, actionEnum: ActionEnum) {
        self.handDelegate = handDelegate
        self.actionEnum = .JumpAction
        self.action = JumpAction(delegate: handDelegate)
        super.init(frame: frame)
        changeAction(actionEnum: actionEnum)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    // NOTE: Don't forget to call this method in ARViewContainer
    func setupForBodyTracking() {
        let config = ARBodyTrackingConfiguration()
        self.session.run(config)
        self.session.delegate = self
    }

    // Implement ARSession didUpdate anchors delegate method
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            theCharacterAnchor.position = bodyPosition + theCharacterOffset
            
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            theCharacterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            if let character = theCharacter, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                theCharacterAnchor.addChild(character)
            }
            
            let str = posekit.BodyTrackingPosition(character: theCharacter, bodyAnchor: bodyAnchor)
            let json: PoseKit.json_BodyPositions = try! decoder.decode(PoseKit.json_BodyPositions.self, from: str.data(using: .utf8)!)
            action.counting(json: json)
            
            // 手
//            print("position_leftArm: \(json.position_leftArm)")
//            print("json.position_rightArm: \(json.position_rightArm)")
//            print("json.position_leftForearm: \(json.position_leftForearm)")
//            print("json.position_rightForearm: \(json.position_rightForearm)")
            // 腳
//            print("json.position_leftLeg: \(json.position_leftLeg)")
//            print("json.position_rightLeg: \(json.position_rightLeg)")
//            print("json.position_leftForeleg: \(json.position_leftForeleg)")
//            print("json.position_rightForeleg: \(json.position_rightForeleg)")
//            print()
        }
    }
    
    func changeAction(actionEnum: ActionEnum) {
        if self.actionEnum != actionEnum {
            self.actionEnum = actionEnum
            
            switch actionEnum {
            case .JumpAction:
                print("JumpAction")
                self.action = JumpAction(delegate: handDelegate)
            case .CrouchAction:
                print("CrouchAction")
                self.action = CrouchAction(delegate: handDelegate)
            }
        }
        
    }
}

var myArView: MyARView?

struct ARViewContainer: UIViewRepresentable {
    @Binding var actionEnum: ActionEnum
    @Binding var count: Int
    
    class Coordinator: NSObject, PoseDelegate {
        var count: Binding<Int>
        
        init(_ count: Binding<Int>) {
            self.count = count
        }
        
        func counting(count: Int) {
            self.count.wrappedValue = count
        }
    }
    
    func makeUIView(context: Context) -> MyARView {
        let arView = MyARView(frame: .zero, handDelegate: context.coordinator, actionEnum: actionEnum)
        myArView = arView
        arView.handDelegate = context.coordinator
        arView.setupForBodyTracking()
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        arView.scene.addAnchor(arView.theCharacterAnchor)

        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                arView.theCharacter = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        
        return arView
    }

    func updateUIView(_ uiView: MyARView, context: Context) {
        if count == 0 {
            uiView.action.cleanCount()
        }
        
        uiView.changeAction(actionEnum: actionEnum)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($count)
    }
}

#endif
