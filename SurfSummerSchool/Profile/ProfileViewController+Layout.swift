//
//  ProfileViewController+Layout.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 02.08.2023.
//

import Foundation
import UIKit

extension ProfileViewController {
    func setupNavBar() {
        navigationItem.title = "Профиль"
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        setupHeader()
        setupCollection()
    }
    
    private func setupHeader() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 19),
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -51),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 51),
            headerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        headerView.configure(with: viewModel.model)
    }
    
    private func setupCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileViewController {
    /// Лучше не знать, что тут происходит)
    func layoutHeaderWithScroll(offset: CGFloat) {
        let offset = offset + 19 + 21
        
        guard offset < 0 else {
            headerView.isHidden = true
            return
        }
        
        headerView.isHidden = false
        
        let height = headerView.bounds.height + 24
        let scale = abs(offset) / height
        
        headerView.anchorPoint = .init(x: 0.5, y: 0)
        headerView.transform = CGAffineTransform(scaleX: scale, y: scale)
        headerView.layer.position = .init(x: view.bounds.width / 2, y: view.safeAreaInsets.top + 24)
    }
    
    func layoutBackgroundWithScroll(offset: CGFloat) {
        let offset = offset + 21
        
        guard offset < 0 else {
            backgroundView.isHidden = true
            return
        }
        backgroundView.isHidden = false
        
        let height = backgroundView.bounds.height - view.safeAreaInsets.top
        var alpha = abs(offset) / height
        alpha = -(cos(.pi * alpha) - 1) / 2
        
        backgroundView.backgroundColor = .systemGray6.withAlphaComponent(alpha * alpha)
        backgroundView.layer.position = .init(x: view.bounds.width / 2, y: 0)
        backgroundView.anchorPoint = .init(x: 0.5, y: 0)
        backgroundView.transform = CGAffineTransform(scaleX: 1, y: alpha)
    }
}

extension ProfileViewController {
    var collectionViewLayout: UICollectionViewCompositionalLayout {
        let skillsSection = {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(120),
                                                                heightDimension: .estimated(44)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                           heightDimension: .estimated(250)),
                                                         subitems: [item])
            group.interItemSpacing = .fixed(12)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                          heightDimension: .estimated(24)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top,
                                                        absoluteOffset: .init(x: 0, y: -16))]
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 0, leading: 0, bottom: 24, trailing: 0)
            return section
        }
        
        let aboutSection = {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .estimated(150)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                           heightDimension: .estimated(150)),
                                                         subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                          heightDimension: .estimated(24)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top,
                                                        absoluteOffset: .init(x: 0, y: -8))]
            
            return section
        }
        
        return .init { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            
            let section = self.viewModel.sections[sectionIndex]
            switch section {
            case .about: return aboutSection()
            case .skills: return skillsSection()
            }
        }
    }
}
