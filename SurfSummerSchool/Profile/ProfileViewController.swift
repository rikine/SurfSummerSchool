//
//  ViewController.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6.withAlphaComponent(1)
        return view
    }()
    lazy var headerView = TitleProfileView()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(SkillCollectionCell.self,
                            forCellWithReuseIdentifier: SkillCollectionCell.self.description())
        collection.register(SkillHeaderCollectionView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: SkillHeaderCollectionView.self.description())
        collection.register(DescriptionCollectionView.self,
                            forCellWithReuseIdentifier: DescriptionCollectionView.self.description())
        return collection
    }()
    
    let viewModel: any ProfileViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = ProfileViewModel(skills: [])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init<T: ProfileViewModelProtocol>(_ viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset.top = headerView.bounds.height + 24 + 19 + 21
    }
    
    private func setupBindings() {
        viewModel.combinedSkillsAndIsEditing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.updateCollectionView()
            }.store(in: &cancellables)
        
        collectionView.publisher(for: \.contentOffset, options: .new)
            .throttle(for: 0.01, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] point in
                let offset = point.y
                self?.layoutHeaderWithScroll(offset: offset)
                self?.layoutBackgroundWithScroll(offset: offset)
            }.store(in: &cancellables)
    }
    
    private func updateCollectionView() {
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.reloadSections(IndexSet(0..<(self?.collectionView.numberOfSections ?? 0)))
        })
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .skills(let items):
            let skill = items[indexPath.row]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillCollectionCell.self.description(), for: indexPath) as? SkillCollectionCell else {
                return .init()
            }
            
            /// Когда ячейка больше, чем ширина коллекции, происходит краш, как решить.....
            /// Костыль
            if let widthConstraint = cell.skillView.constraints.first(where: { $0.firstAttribute == .width }) {
                widthConstraint.constant = collectionView.bounds.width
            } else {
                cell.skillView.widthAnchor.constraint(lessThanOrEqualToConstant: collectionView.bounds.width).isActive = true
            }
            cell.configure(item: skill, isEditing: skill == .add ? false : viewModel.isEditing) /// Лучше запихать Binding
            cell.skillView.onButtonTap = { [weak self] in
                self?.viewModel.removeSkill(skill)
            }
            
            return cell
            
        case .about(let text):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionView.self.description(),
                                                                for: indexPath) as? DescriptionCollectionView else {
                return .init()
            }
            
            cell.configure(with: text)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: SkillHeaderCollectionView.self.description(),
                                                                               for: indexPath)
                    as? SkillHeaderCollectionView else {
                return .init()
            }
            
            switch viewModel.sections[indexPath.section] {
            case .skills: header.configure(isEditing: viewModel.isEditing)
            case .about: header.configure(withButton: false)
            }
            
            header.headerView.onButtonTap = { [weak self] in
                self?.viewModel.isEditing.toggle()
            }
            
            return header
        default:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .skills:
            guard viewModel.skills[indexPath.row] == .add else { return }
            showAddSkillAlert()
        default: break
        }
    }
}

extension ProfileViewController {
    private func showAddSkillAlert() {
        let controller = UIAlertController(title: "Добавление навыка",
                                           message: "Введите название навыка которым вы владеете",
                                           preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        controller.addAction(.init(title: "Отмена", style: .default))
        
        let action = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            controller.textFields?.first?.text.map {
                self?.viewModel.addSkill(.init(title: $0))
            }
        }
        controller.addAction(action)
        controller.preferredAction = action
        
        present(controller, animated: true)
    }
}
