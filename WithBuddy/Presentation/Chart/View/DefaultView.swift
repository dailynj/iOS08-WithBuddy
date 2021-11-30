//
//  DefaultView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class DefaultView: UIView {

    private let imageViewSize = CGFloat(65)
    private let imageView = UIImageView()
    private let label = PurpleLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.configureImageView()
        self.configureLabel()
    }
    
    private func configureImageView() {
        self.addSubview(self.imageView)
        self.imageView.image = .purpleFaceImage
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: .plusInset),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: self.imageViewSize),
            self.imageView.heightAnchor.constraint(equalToConstant: self.imageViewSize)
        ])
    }
    
    private func configureLabel() {
        self.addSubview(self.label)
        self.label.text = "기록이 없어요"
        self.label.textAlignment = .center
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: .innerPartInset),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
