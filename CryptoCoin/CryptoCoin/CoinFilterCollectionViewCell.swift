//
//  CoinFilterCollectionViewCell.swift
//  CryptoCoin
//
//  Created by Suresh M on 28/11/24.
//

import Foundation
import UIKit

class CoinFilterCollectionViewCell: UICollectionViewCell {
    static let identifier = "CoinFilterCollectionViewCell"
    
    var label: UILabel?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        hStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        imageView = UIImageView()
        imageView?.image = UIImage(named: "right")
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        hStack.addArrangedSubview(imageView!)
        
        label = UILabel()
        label?.font = .systemFont(ofSize: 15)
        label?.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(label!)
        
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CoinFilterModel) {
        label?.text = model.title
        if model.isSelected {
            imageView?.isHidden = false
            self.backgroundColor = UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 209.0 / 255.0, alpha: 1)
        } else {
            imageView?.isHidden = true
            self.backgroundColor = UIColor(red: 229.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 1)
        }
    }
}
