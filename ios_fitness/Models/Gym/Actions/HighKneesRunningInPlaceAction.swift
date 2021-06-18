//
//  HighKneesRunningInPlaceAction.swift
//  ios_fitness
//
//  Created by jakey on 2021/6/6.
//

import Foundation

#if arch(arm64)

import Foundation

// 原地提膝踏步
public class HighKneesRunningInPlaceAction: Action {
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
//        switch json.position_leftArm.position { // 左手臂
//            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
//                leftUp = true
//            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue:
//                leftDown = true
//        default:
//            break
//        }
//
//        switch json.position_rightArm.position { // 右手臂
//            case ShoulderToForearmSubcase.verticalUpDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalUpTransverse.rawValue:
//                rightUp = true
//            case ShoulderToForearmSubcase.verticalDownDiagonalFront.rawValue, ShoulderToForearmSubcase.verticalDownDiagonalBack.rawValue, ShoulderToForearmSubcase.verticalDownParallel.rawValue, ShoulderToForearmSubcase.verticalDownTransverse.rawValue:
//                rightDown = true
//        default:
//            break
//        }
        
        switch json.position_leftForearm.position { // 左手臂
        case ForearmToHandSubcase.bentUp.rawValue, ForearmToHandSubcase.bentUpOut.rawValue, ForearmToHandSubcase.bentUpIn.rawValue, ForearmToHandSubcase.horizontalBentIn.rawValue:
                leftUp = true
        case ForearmToHandSubcase.bentDown.rawValue, ForearmToHandSubcase.bentDownOut.rawValue, ForearmToHandSubcase.bentDownIn.rawValue, ForearmToHandSubcase.straightHorizontal.rawValue:
                leftDown = true
        default:
            break
        }

        switch json.position_rightForearm.position { // 右手臂
        case ForearmToHandSubcase.bentUp.rawValue, ForearmToHandSubcase.bentUpOut.rawValue, ForearmToHandSubcase.bentUpIn.rawValue, ForearmToHandSubcase.horizontalBentIn.rawValue:
                rightUp = true
        case ForearmToHandSubcase.bentDown.rawValue, ForearmToHandSubcase.bentDownOut.rawValue, ForearmToHandSubcase.bentDownIn.rawValue, ForearmToHandSubcase.straightHorizontal.rawValue:
                rightDown = true
        default:
            break
        }
        
        if (leftUp && leftDown) && (rightDown && rightUp) {
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
