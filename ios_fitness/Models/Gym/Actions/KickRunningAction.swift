//
//  KickRunningAction.swift
//  ios_fitness
//
//  Created by jakey on 2021/6/6.
//

#if arch(arm64)

import Foundation

// 踢臀跑
public class KickRunningAction: Action {
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
        switch json.position_leftForeleg.position { // 左腳
        case KneeToFootCase.bent.rawValue, KneeToFootCase.bentIn.rawValue, KneeToFootCase.bentOut.rawValue:
            leftUp = true
        case KneeToFootCase.outstretched.rawValue:
            leftDown = true
        default:
            break
        }

        switch json.position_rightForeleg.position { // 右腳
        case KneeToFootCase.bent.rawValue, KneeToFootCase.bentIn.rawValue, KneeToFootCase.bentOut.rawValue:
            rightUp = true
        case KneeToFootCase.outstretched.rawValue:
            rightDown = true
        default:
            break
        }

        if (leftUp && leftDown) && (rightUp && rightDown) {
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
