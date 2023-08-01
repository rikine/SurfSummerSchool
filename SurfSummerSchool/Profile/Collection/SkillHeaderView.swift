//
//  SkillHeaderView.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation
import UIKit

final class SkillHeaderView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Мои навыки"
        return label
    }()
    
    lazy var button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config, primaryAction: .init(handler: { [weak self] _ in
            self?.onButtonTap?()
        }))
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted, .focused, .selected: button.alpha = 0.5
                default: button.alpha = 1
                }
            }
        }
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private var stackViewConstraints: [NSLayoutConstraint] {
        [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }
    
    var onButtonTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("NO STORYBOARDS!")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    func configure(isEditing: Bool, withButton: Bool) {
        button.setImage(isEditing ? UIImage(named: "done") : UIImage(named: "pencil"), for: .normal)
        button.isHidden = !withButton
    }
}

final class SkillHeaderCollectionView: UICollectionReusableView {
    lazy var headerView = SkillHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("NO STORYBOARDS!")
    }
    
    private func setup() {
        addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(isEditing: Bool = false, withButton: Bool = true) {
        headerView.configure(isEditing: isEditing, withButton: withButton)
    }
}
