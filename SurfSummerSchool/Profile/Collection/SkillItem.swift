//
//  SkillItem.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation

struct SkillItem: Hashable {
    let title: String
    
    static let add = SkillItem(title: "+")
}

extension Array where Element == SkillItem {
    static let example = [
        SkillItem(title: "MVP/MVVM"),
        SkillItem(title: "Swift Coroutines"),
        SkillItem(title: "REST API"),
        SkillItem(title: "CoreData"),
        SkillItem(title: "Custom View"),
        SkillItem(title: "ООП и SOLID"),
        SkillItem(title: "DataStore"),
        SkillItem(title: "WorkManager"),
        SkillItem(title: "Room"),
        SkillItem(title: "OKHttp"),
    ]
    
    static let exampleLong = [
        SkillItem(title: "MVP/MVVM"),
        SkillItem(title: "Swift Coroutines"),
        SkillItem(title: "REST API"),
        SkillItem(title: "CoreData"),
        SkillItem(title: "Custom View"),
        SkillItem(title: "ООП и SOLID"),
        SkillItem(title: "DataStore"),
        SkillItem(title: "WorkManager"),
        SkillItem(title: "Room"),
        SkillItem(title: "Get/Put/Post/Delete/Update"),
        SkillItem(title: "OperationQueue"),
        SkillItem(title: "GCD"),
        SkillItem(title: "Combine"),
        SkillItem(title: "SwiftUI"),
        SkillItem(title: "UIKit"),
        SkillItem(title: "BackgroundTasks"),
        SkillItem(title: "Pushes with Firebase and APNS"),
        SkillItem(title: "Pushes with Firebase and APNS And Everything else if u understand"),
    ]
}
