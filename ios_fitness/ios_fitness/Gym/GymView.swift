//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

#if arch(arm64)

import SwiftUI
import RealityKit
import ARKit
import Combine


// The 3D character to display.
var theCharacter: BodyTrackedEntity?
let characterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
let characterAnchor = AnchorEntity()


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
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }

            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            print("position\(characterAnchor.position)")

            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation

            if let character = theCharacter, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
        }
    }

}

#endif


struct GymView: View {
    var body: some View {
        #if arch(arm64)
        return ARViewContainer()
            .edgesIgnoringSafeArea(.all)
        #else
            Text("運動場")
        #endif
    }
}



