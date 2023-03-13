//
//  DropDownMenuViewController.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/8.
//

import UIKit

class DropDownMenuViewController: UIViewController {
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
            view.backgroundColor = dropDownMenuBackgroundColor
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}


// MARK: - CollectionView Delegate
extension DropDownMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
