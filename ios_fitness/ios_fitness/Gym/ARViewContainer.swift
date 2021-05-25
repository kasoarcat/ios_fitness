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

// The 3D character to display.
private var theCharacter: BodyTrackedEntity?
private let characterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
private let characterAnchor = AnchorEntity()
private let posekit = PoseKit()
private let decoder = JSONDecoder()

struct ARViewContainer: UIViewRepresentable {
    typealias UIViewType = ARView

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.setupForBodyTracking()

        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        arView.scene.addAnchor(characterAnchor)

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
                theCharacter = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}


// ARView to implement body tracking functionalty
extension ARView: ARSessionDelegate {
    // NOTE: Don't forget to call this method in ARViewContainer
    func setupForBodyTracking() {
        let config = ARBodyTrackingConfiguration()
        self.session.run(config)
        self.session.delegate = self
    }

    // Implement ARSession didUpdate anchors delegate method
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        var count = 0
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            count += 1
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
//            print("position: \(characterAnchor.position)")
            
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
//            print("count:\(count) rotation: \(characterAnchor.orientation.angle)")
            
            if let character = theCharacter, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
            
            let str = posekit.BodyTrackingPosition(character: theCharacter, bodyAnchor: bodyAnchor)
            let json: PoseKit.json_BodyPositions = try! decoder.decode(PoseKit.json_BodyPositions.self, from: str.data(using: .utf8)!)
            
            var s: String = ""
            switch json.position_leftArm.position { // 左手臂
            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue:
                s = "直上對角前"
            case ShoulderToForearmSubcase.verticalUpParallel.rawValue:
                s = "垂直平行"
            case ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
                s = "直上橫"
            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue:
                s = "直下對角前"
            case ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue:
                s = "直下對角後"
            case ShoulderToForearmSubcase.verticalDownParallel.rawValue:
                s = "直下平行"
            case ShoulderToForearmSubcase.verticalDownTransverse.rawValue:
                s = "直下橫"
            case ShoulderToForearmSubcase.horizontalParallel.rawValue:
                s = "水平平行"
            case ShoulderToForearmSubcase.horizontalDiagonalBack.rawValue:
                s = "平橫背"
            case ShoulderToForearmSubcase.horizontalDiagonalFront.rawValue:
                s = "平橫前"
            case ShoulderToForearmSubcase.horizontalTransverse.rawValue:
                s = "水平橫"
            default:
                s = ""
            }
            print("leftArm:", s)
            
//            print("leftArm: \()")
            
//            JSON: {
//              "position_leftForeleg" : {
//                "name" : "leftForeleg",           // 左前腿
//                "position" : "outstretched"       // outstretched=>伸出
//              },
//              "position_rightArm" : {
//                "name" : "rightArm",              // 右手臂
//                "position" : "horizontalParallel" // horizontalParallel=>水平平行
//              },
//              "position_leftLeg" : {
//                "name" : "leftLeg",               // 左腿
//                "position" : "straightParallel"   // straightParallel=>直立平行
//              },
//              "position_rightLeg" : {
//                "name" : "rightLeg",              // 右腿
//                "position" : "straightParallel"   // straightParallel=>直立平行
//              },
//              "position_leftForearm" : {
//                "name" : "leftForearm",           // 左前臂
//                "position" : "straightHorizontal" // straightParallel=>直立平行
//              },
//              "position_rightForearm" : {
//                "name" : "rightForearm",          // 右前臂
//                "position" : "straightHorizontal" // straightParallel=>直立平行
//              },
//              "position_leftArm" : {
//                "name" : "leftArm",               // 左手臂
//                "position" : "horizontalParallel" // horizontalParallel=>水平平行
//              },
//              "position_rightForeleg" : {
//                "name" : "rightForeleg",          // 右前腿
//                "position" : "straightParallel"   // straightParallel=>直立平行
//              }
//            }

        }
    }
}

#endif
