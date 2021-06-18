//
//  PositionCases.swift
//  poseKit-iOS
//
//  Created by Vinicius Dilay on 07/11/19.
//  Copyright © 2019 d1l4y. All rights reserved.
//

#if arch(arm64)

import Foundation

/// Upper arm's position cases
/// 肩膀到前臂 Case
public enum ShoulderToForearmCase {
    case verticalUp         // 上
    case verticalDown       // 下
    case horizontal         // 水平
}

/// Upper arm's position subcases.
/// 肩膀到前臂 Subcase
public enum ShoulderToForearmSubcase: String {
    case verticalUpDiagonalFront        // 直上對角前
    case verticalUpParallel             // 垂直平行
    case verticalUpTransverse           // 直上橫
    
    case verticalDownDiagonalFront      // 直下對角前
    case verticalDownDiagonalBack       // 直下對角後
    case verticalDownParallel           // 直下平行
    case verticalDownTransverse         // 直下橫
    
    case horizontalParallel             // 水平平行
    case horizontalDiagonalBack         // 平橫背
    case horizontalDiagonalFront        // 平橫前
    case horizontalTransverse           // 水平橫
}

/// Forearm's position cases.
/// 前臂到手臂 Case
public enum ForearmToHandForearmCase {
    case straightHorizontal
    case bentUp
    case bentDown
}

/// Forearm's position subcases.
/// 前臂到手臂 Subcase
public enum ForearmToHandSubcase: String {
    case straightHorizontal
    case horizontalBentIn
    
    case bentUp
    case bentUpOut
    case bentUpIn
    
    case bentDown
    case bentDownOut
    case bentDownIn
}

/// Upper leg's position cases.
/// 腿到膝蓋 Case
public enum LegToKneeCase {
    case straight
    case halfOpen
    case Open
}

/// Upper leg's position subcases.
/// 腿到膝蓋 Subcase
public enum LegToKneeSubcase: String {
    case straightParallel           // 直立平行
    case straightBack               // 直立後
    
    case halfOpenDiagonal           // 半開對角
    case halfOpenParallel           // 半開平
    case halfOpenTransversal        // 半開橫向
    
    case openParallel               // 開平
    case openDiagonal               // 開對角
    case openTransversal            // 開橫向
}

/// Lower leg's position cases.
/// 膝蓋到腳 Case
public enum KneeToFootCase: String {
    case outstretched               // 伸出
    case bentOut
    case bent                       // 彎曲
    case bentIn                     // 彎腰
}

/// Both leg's position cases.
public enum BothLegsCase {
    
}

#endif
