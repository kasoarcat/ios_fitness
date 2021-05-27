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
    func handCount(count: Int)
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var handCount: Int
    
    class MyARView : ARView, ARSessionDelegate {
        // The 3D character to display.
        var theCharacter: BodyTrackedEntity?
        private let theCharacterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
        let theCharacterAnchor = AnchorEntity()
        private let posekit = PoseKit()
        private let decoder = JSONDecoder()
        
        private var count: Int = 0
        private var left_up = false
        private var left_down = false
        private var right_up = false
        private var right_down = false
        
        var handDelegate: HandDelegate?
        
//        var handCountClosure: (Int)->Void
        
//        init(frame: CGRect, closure: ((Int)->Void)) {
//            super.init(frame: frame)
//            handCountClosure = closure
//        }
        
//        @objc required dynamic init?(coder decoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        @objc override required dynamic init(frame frameRect: CGRect) {
//            super.init(frame: frameRect)
//        }
        
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
                
                countHand(json: json, delegate: handDelegate)
            }
        }

        func countHand(json: PoseKit.json_BodyPositions, delegate: HandDelegate?) {
        //    var s: String = ""
            switch json.position_leftArm.position { // 左手臂
                case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
        //                    s = "上"
                    left_up = true
                case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue, ShoulderToForearmSubcase.verticalUpParallel.rawValue:
        //                    s = "下"
                    left_down = true
            default:
                break
            }

            switch json.position_rightArm.position { // 右手臂
                case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
        //                    s = "上"
                    right_up = true
                case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue, ShoulderToForearmSubcase.verticalUpParallel.rawValue:
        //                    s = "下"
                    right_down = true
            default:
                break
            }

            if left_up && left_down && right_up && right_down {
                left_up = false
                left_down = false
                right_up = false
                right_down = false
                count += 1
        //        print("count: \(count)")
                
                if let delegate = delegate {
                    delegate.handCount(count: count)
                }
            }

        //    switch json.position_leftLeg.position {
        //    case LegToKneeSubcase.straightParallel.rawValue, LegToKneeSubcase.straightBack.rawValue:
        //        print("straight")
        //    case LegToKneeSubcase.halfOpenDiagonal.rawValue, LegToKneeSubcase.halfOpenParallel.rawValue, LegToKneeSubcase.halfOpenTransversal.rawValue:
        //        print("half")
        //    case LegToKneeSubcase.openParallel.rawValue, LegToKneeSubcase.openDiagonal.rawValue, LegToKneeSubcase.openTransversal.rawValue:
        //        print("open")
        //    default:
        //        print("Error!")
        //    }
        }
    } // end class MyARView
    
    class Coordinator: NSObject, HandDelegate {
        var count: Binding<Int>
        
        init(_ count: Binding<Int>) {
            self.count = count
        }
        
        func handCount(count: Int) {
            self.count.wrappedValue = count
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
//        print("updateUIView")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($handCount)
    }
}

#endif
