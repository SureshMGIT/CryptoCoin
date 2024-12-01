//
//  CoinTableViewCell.swift
//  CryptoCoin
//
//  Created by Suresh M on 29/11/24.
//

import UIKit

final class CoinTableViewCell: UITableViewCell {

    static let reuseIdentifier = "cell"
    
    var title: UILabel?
    var typeLabel: UILabel?
    var coinImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        selectionStyle = .none
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalStackView)
        horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        title = UILabel()
        title?.font = .systemFont(ofSize: 15)
        title?.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(title!)
        
        typeLabel = UILabel()
        typeLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        typeLabel?.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(typeLabel!)
        
        let view1 = UIView()
        view1.heightAnchor.constraint(equalToConstant: 10).isActive = true
        verticalStackView.addArrangedSubview(view1)
        
        coinImageView = UIImageView()
        coinImageView?.translatesAutoresizingMaskIntoConstraints = false
        coinImageView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        coinImageView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        horizontalStackView.addArrangedSubview(coinImageView!)
        
    }
    
    func configureCell(model: CoinModel) {
        title?.text = model.name
        typeLabel?.text = model.symbol
        if model.isActive {
            coinImageView?.image = UIImage(named: "coin_active")
        } else if model.type == .token && model.isActive {
            coinImageView?.image = UIImage(named: "token_coin_active")
        } else if !model.isActive {
            coinImageView?.image = UIImage(named: "inactive")
        } else if model.isNew {
            coinImageView?.image = UIImage(named: "coin_new")
        }
    }
}
