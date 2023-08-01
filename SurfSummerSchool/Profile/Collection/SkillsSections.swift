//
//  SkillsSections.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation

enum SkillsSections {
    case skills([SkillItem])
    case about(String)
    
    var count: Int {
        switch self {
        case .skills(let items): return items.count
        case .about: return 1
        }
    }
}
