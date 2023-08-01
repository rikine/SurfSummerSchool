//
//  ProfileViewModel.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol: ObservableObject {
    var skills: [SkillItem] { get set }
    var isEditing: Bool { get set }
    var model: ProfileModel { get }
    var sections: [SkillsSections] { get }
    var combinedSkillsAndIsEditing: AnyPublisher<([SkillItem], Bool), Never> { get }
    
    func removeSkill(_ skill: SkillItem)
    func addSkill(_ skill: SkillItem)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    var skills: [SkillItem] {
        didSet {
            combinerSkillsPublisher.send((Array(Set(skills)), isEditing))
        }
    }
    
    var isEditing = false {
        didSet {
            isEditingChanged()
        }
    }
    
    var sections: [SkillsSections] { [.skills(skills), .about(model.about)] }
    
    private var combinerSkillsPublisher = PassthroughSubject<([SkillItem], Bool), Never>()
    var combinedSkillsAndIsEditing: AnyPublisher<([SkillItem], Bool), Never> {
        combinerSkillsPublisher.eraseToAnyPublisher()
    }
    
    let model: ProfileModel
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(skills: [SkillItem], model: ProfileModel = .example) {
        self.skills = skills
        self.model = model
    }
    
    func removeSkill(_ skill: SkillItem) {
        skills.remove(item: skill)
    }
    
    private func isEditingChanged() {
        if isEditing {
            skills.append(.add)
        } else {
            skills.remove(item: .add)
        }
    }
    
    func addSkill(_ skill: SkillItem) {
        guard !skills.contains(where: { $0 == skill }) else {
            print("This skill is already added")
            return
        }
        
        skills.insert(skill, at: skills.firstIndex(of: .add) ?? skills.endIndex)
    }
}
