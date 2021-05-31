//
//  SquattingUpAction.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/30.
//

#if arch(arm64)

import Foundation

// 蹲姿上伸
public class SquattingUpAction: Action {
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

        if (leftUp && leftDown) || (rightUp && rightDown) {
            leftUp = false
            leftDown = false
            rightUp = false
            rightDown = false
            count += 1
            
            delegate.counting(count: count)
        }
    }
    
}

#endif
