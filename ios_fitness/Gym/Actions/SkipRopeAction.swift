//
//  SkipRopeAction.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/30.
//

import Foundation

// 無線跳繩
public class SkipRopeAction: Action {
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
//        if json.position_leftArm.position == ShoulderToForearmSubcase.horizontalTransverse.rawValue && json.position_rightArm.position == ShoulderToForearmSubcase.horizontalTransverse.rawValue {
//
//            if json.position_leftLeg.position == LegToKneeSubcase.straightParallel.rawValue && json.position_rightLeg.position == LegToKneeSubcase.straightParallel.rawValue {
//                up = true
//            }
//            else if json.position_leftLeg.position == LegToKneeSubcase.openTransversal.rawValue && json.position_rightLeg.position == LegToKneeSubcase.openTransversal.rawValue {
//                down = true
//            }
//
//            if up && down {
//                up = false
//                down = false
//                count += 1
//                delegate.counting(count: count)
//            }
//        }
    }
    
}
