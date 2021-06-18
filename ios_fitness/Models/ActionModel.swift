//
//  ActionModel.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/11.
//

import Foundation
import SwiftUI

struct ActionModel: Identifiable {
   var id = UUID()
   var title: ActionEnum
   var image: String
   var color: Color
   var shadowColor: Color
}
