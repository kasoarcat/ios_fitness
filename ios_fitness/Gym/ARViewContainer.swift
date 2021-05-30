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
        self.actionEnum = .開合跳
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
            print("position_leftArm: \(json.position_leftArm)")
            print("json.position_rightArm: \(json.position_rightArm)")
//            print("json.position_leftForearm: \(json.position_leftForearm)")
//            print("json.position_rightForearm: \(json.position_rightForearm)")
            // 腳
//            print("json.position_leftLeg: \(json.position_leftLeg)")
//            print("json.position_rightLeg: \(json.position_rightLeg)")
//            print("json.position_leftForeleg: \(json.position_leftForeleg)")
//            print("json.position_rightForeleg: \(json.position_rightForeleg)")
            print()
        }
    }
    
    func changeAction(actionEnum: ActionEnum) {
        if self.actionEnum != actionEnum {
            self.actionEnum = actionEnum
            
            switch actionEnum {
            case .開合跳:
                print("開合跳")
                self.action = JumpAction(delegate: handDelegate)
            case .蹲伏:
                print("蹲伏")
                self.action = CrouchAction(delegate: handDelegate)
//            case .無線跳繩:
//                print("無線跳繩")
//                self.action = SkipRopeAction(delegate: handDelegate)
            case .蹲姿上伸:
                print("蹲姿上伸")
                
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
