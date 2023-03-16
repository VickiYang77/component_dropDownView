//
//  DropDownMenuCell.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/8.
//

import UIKit

struct DropDownMenuCellModel: Hashable {
    var title: String
    var isCellSelected: Bool
}

class DropDownMenuCell: UICollectionViewCell {
    static let identifier = "DropDownMenuCell"
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.5
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var isCellSelected: Bool = false {
        didSet {
            self.titleLabel.textColor = isCellSelected ? #colorLiteral(red: 0.3172737062, green: 0.5509234667, blue: 0.7587964535, alpha: 1) : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        isCellSelected = false
    }
}
