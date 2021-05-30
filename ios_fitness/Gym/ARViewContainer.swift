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

public protocol HandDelegate : NSObjectProtocol {
    func handCount(jumpCount: Int)
    func crouchCount(jumpCount: Int)
}

class MyARView : ARView, ARSessionDelegate {
    // The 3D character to display.
    var theCharacter: BodyTrackedEntity?
    private let theCharacterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
    let theCharacterAnchor = AnchorEntity()
    private let posekit = PoseKit()
    private let decoder = JSONDecoder()
    
    // 開合跳
    var jumpCount: Int = 0
    private var left_up = false
    private var left_down = false
    private var right_up = false
    private var right_down = false
    
    // 蹲伏
    var crouchCount: Int = 0
    private var crouchUp = false
    private var crouchDown = false
    
    var handDelegate: HandDelegate?
    
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
            
            countJump(json: json)
            countCrouch(json: json)
            
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

    // 開合跳
    func countJump(json: PoseKit.json_BodyPositions) {
    //    var s: String = ""
        switch json.position_leftArm.position { // 左手臂
            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
                left_up = true
            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue, ShoulderToForearmSubcase.verticalUpParallel.rawValue:
                left_down = true
        default:
            break
        }

        switch json.position_rightArm.position { // 右手臂
            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
                right_up = true
            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue, ShoulderToForearmSubcase.verticalUpParallel.rawValue:
                right_down = true
        default:
            break
        }

        if left_up && left_down && right_up && right_down {
            left_up = false
            left_down = false
            right_up = false
            right_down = false
            jumpCount += 1
    //        print("jumpCount: \(jumpCount)")
            
            if let delegate = handDelegate {
                delegate.handCount(jumpCount: jumpCount)
            }
        }
    }
    
    // 蹲伏
    func countCrouch(json: PoseKit.json_BodyPositions) {
        if json.position_leftArm.position == ShoulderToForearmSubcase.horizontalTransverse.rawValue && json.position_rightArm.position == ShoulderToForearmSubcase.horizontalTransverse.rawValue {
            
            if json.position_leftLeg.position == LegToKneeSubcase.straightParallel.rawValue && json.position_rightLeg.position == LegToKneeSubcase.straightParallel.rawValue {
                crouchUp = true
            }
            else if json.position_leftLeg.position == LegToKneeSubcase.openTransversal.rawValue && json.position_rightLeg.position == LegToKneeSubcase.openTransversal.rawValue {
                crouchDown = true
            }
            
            if crouchUp && crouchDown {
                crouchUp = false
                crouchDown = false
                crouchCount += 1
                
                if let delegate = handDelegate {
                    delegate.crouchCount(jumpCount: crouchCount)
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var handCount: Int
    @Binding var crouchCount: Int
    
    class Coordinator: NSObject, HandDelegate {
        var handCount: Binding<Int>
        var crouchCount: Binding<Int>
        
        init(_ handCount: Binding<Int>, _ crouchCount: Binding<Int>) {
            self.handCount = handCount
            self.crouchCount = crouchCount
        }
        
        func handCount(jumpCount: Int) {
            self.handCount.wrappedValue = jumpCount
        }
        
        func crouchCount(jumpCount: Int) {
            self.crouchCount.wrappedValue = jumpCount
        }
    }
    
    func makeUIView(context: Context) -> MyARView {
        let arView = MyARView(frame: .zero)
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
        uiView.jumpCount = handCount
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($handCount, $crouchCount)
    }
}

#endif
