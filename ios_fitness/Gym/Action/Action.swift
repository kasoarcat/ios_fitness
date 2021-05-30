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

//JumpAction CrouchAction
enum ActionEnum: String, CaseIterable {
    case 開合跳
    case 蹲伏
}

