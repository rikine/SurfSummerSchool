//
//  ProfileModel.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation
import UIKit

struct ProfileModel {
    let imageName: String
    let name: String
    let description: String?
    let place: String?
    
    let about: String
    
    var image: UIImage? { UIImage(named: imageName) }
    
    static let example = ProfileModel(imageName: "kitty",
                                      name: "Иванов Иван\nИванович",
                                      description: "Middle iOS-разработчик, опыт более 2-х лет",
                                      place: "Воронеж",
                                      about: "Experienced software engineer skilled in developing scalable and maintainable systems")
}
