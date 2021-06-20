//
//  Action.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/30.
//

#if arch(arm64)

import Foundation

public protocol PoseDelegate : NSObjectProtocol {
    func counting(count: Int)
}

protocol Action {
    var count: Int { get }
    
    func cleanCount()
    func counting(json: PoseKit.json_BodyPositions)
}

#endif

enum CaloriesSpec {
    case light
    case medium
    case heavy
}

enum ActionEnum: String, CaseIterable {
    case 開合跳         // JumpAction
    case 蹲伏           // CrouchAction
//    case 無線跳繩      // SkipRopeAction (不好做)
    case 蹲姿上伸        // SquattingUpAction
    case 原地提膝踏步   // HighKneesRunningInPlaceAction
//    case 原地跑        // RunAction (不好做)
    case 蹲跳運動        // SquatJumpAction
//    case 踢臀跑         // KickRunningAction (不好做)
    case 深蹲           // SquatAction
    case 弓步           // LungeAction
    case 交叉勾拳        // CrossUppercutAction
}

