//
//  Action.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/30.
//

import Foundation

public protocol PoseDelegate : NSObjectProtocol {
    func counting(count: Int)
}

protocol Action {
    var count: Int { get }
    
    func cleanCount()
    func counting(json: PoseKit.json_BodyPositions)
}

enum ActionEnum: String, CaseIterable {
    case 開合跳   // JumpAction
    case 蹲伏     // CrouchAction
//    case 無線跳繩  // SkipRopeAction
    case 蹲姿上伸  // SquattingUpAction
}

