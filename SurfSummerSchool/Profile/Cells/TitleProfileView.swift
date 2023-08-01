//
//  TitleProfileView.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation
import UIKit

final class TitleProfileView: UIView {
    lazy var imageView: UIImageView = {
        let size = 120.0
        
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = size / 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    lazy var nameLabel = makeLabel(with: 24, numberOfLines: 2, isBold: true)
    
    lazy var descriptionLabel = makeLabel(with: 14, numberOfLines: 2, isPrimary: false)
    
    lazy var placeLabel = makeLabel(with: 14, isPrimary: false)
    
    lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        return imageView
    }()
    
    lazy var placeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeImageView, placeLabel])
        stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, descriptionLabel, placeStackView])
        stackView.spacing = 4
        stackView.setCustomSpacing(16, after: imageView)
        stackView.setCustomSpacing(0, after: descriptionLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var stackViewConstraints: [NSLayoutConstraint] {
        [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No Storyboard! PLS")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    func configure(with model: ProfileModel) {
        configure(with: model.image, name: model.name, description: model.description, place: model.place)
    }
    
    func configure(with image: UIImage?, name: String, description: String?, place: String?) {
        imageView.image = image ?? UIImage(systemName: "person.crop.rectangle.fill")
        
        nameLabel.text = name
        
        descriptionLabel.textOrHidden(text: description)
        
        placeStackView.isHidden = place == nil
        placeLabel.text = place
    }
    
    private func makeLabel(with size: CGFloat, numberOfLines: Int = 1, isPrimary: Bool = true, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.font = isBold ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = numberOfLines
        label.textColor = isPrimary ? .label : .secondaryLabel
        label.textAlignment = .center
        return label
    }
}

extension UILabel {
    func textOrHidden(text: String?) {
        self.text = text
        isHidden = text == nil
    }
}
