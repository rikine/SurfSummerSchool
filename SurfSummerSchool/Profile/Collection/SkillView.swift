//
//  SkillView.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation
import UIKit

final class SkillView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config, primaryAction: .init(handler: { [weak self] _ in
            self?.onButtonTap?()
        }))
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 14).isActive = true
        button.heightAnchor.constraint(equalToConstant: 14).isActive = true
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
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    private var stackViewConstraints: [NSLayoutConstraint] {
        [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
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
        
        layer.masksToBounds = true
        layer.cornerRadius = 12
        backgroundColor = .systemGray6
    }
    
    func configure(title: String, isEditing: Bool) {
        label.text = title
        button.isHidden = !isEditing
    }
}

final class SkillCollectionCell: UICollectionViewCell {
    lazy var skillView = SkillView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No Storyboards!")
    }
    
    private func setup() {
        contentView.layer.masksToBounds = skillView.layer.masksToBounds
        contentView.layer.cornerRadius = skillView.layer.cornerRadius
        contentView.addSubview(skillView)
        
        NSLayoutConstraint.activate([
            skillView.topAnchor.constraint(equalTo: contentView.topAnchor),
            skillView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            skillView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            skillView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(title: String, isEditing: Bool) {
        skillView.configure(title: title, isEditing: isEditing)
    }
    
    func configure(item: SkillItem, isEditing: Bool) {
        skillView.configure(title: item.title, isEditing: isEditing)
    }

}
