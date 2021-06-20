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

//extension ActionEnum: RawRepresentable {
//    init?(rawValue: (Int, String)) {
//        switch rawValue {
//        case (1, "開合跳"): self = .開合跳
//        case (2, "蹲伏"): self = .蹲伏
//        case (3, "蹲姿上伸"): self = .蹲姿上伸
//        case (4, "原地提膝踏步"): self = .原地提膝踏步
//        case (5, "蹲跳運動"): self = .蹲跳運動
//        case (6, "深蹲"): self = .深蹲
//        case (7, "弓步"): self = .弓步
//        case (8, "交叉勾拳"): self = .交叉勾拳
//        default: return nil
//        }
//    }
//    
//    var rawValue: (Int, String) {
//        switch self {
//        case .開合跳: return (1, "開合跳")
//        case .蹲伏: return (2, "蹲伏")
//        case .蹲姿上伸: return (2, "蹲姿上伸")
//        case .原地提膝踏步: return (2, "原地提膝踏步")
//        case .蹲跳運動: return (2, "蹲跳運動")
//        case .深蹲: return (2, "深蹲")
//        case .弓步: return (2, "弓步")
//        case .交叉勾拳: return (2, "交叉勾拳")
//        }
//    }
//}
