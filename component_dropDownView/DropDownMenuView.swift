//
//  DropDownMenuView.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/12.
//

import UIKit

class DropDownMenuView: UIView {
    var titleDataSource: [String] = []
    var selectedIndex: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    var rowCellCount: Int = 3
    var cellHeight: CGFloat = 50
    var didSelectItemHandler: ((IndexPath) -> ())?
    var dropDownMenuBackgroundColor: UIColor = .black {
        didSet {
            backgroundColor = dropDownMenuBackgroundColor
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(DropDownMenuCell.self, forCellWithReuseIdentifier: DropDownMenuCell.identifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupConstraint()
        collectionView.reloadData()
    }
    
    private func setupConstraint() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}


// MARK: - CollectionView Delegate
extension DropDownMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropDownMenuCell.identifier, for: indexPath) as? DropDownMenuCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < titleDataSource.count {
            cell.titleLabel.text = titleDataSource[indexPath.row]
            cell.isCellSelected = (indexPath.row == selectedIndex)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < titleDataSource.count else { return }
        didSelectItemHandler?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = floor(collectionView.bounds.width / CGFloat(rowCellCount))
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
