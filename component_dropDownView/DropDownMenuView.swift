//
//  DropDownMenuView.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/12.
//

import UIKit

enum menuTypeSection {
    case first
}

class DropDownMenuView: UIView {
    lazy var titles: [String] = [] {
        didSet {
            titleModelDataSource = titles.map{ DropDownMenuCellModel(title: $0, isCellSelected: false) }
            applySnapshot()
        }
    }
    private var titleModelDataSource: [DropDownMenuCellModel] = []
    var selectedIndex: Int = 0 {
        didSet {
            // 改變標題文字顏色
            if titleModelDataSource.count > selectedIndex {
                titleModelDataSource[selectedIndex].isCellSelected = true
                if oldValue != selectedIndex, titleModelDataSource.count > oldValue {
                    titleModelDataSource[oldValue].isCellSelected = false
                }
                applySnapshot()
            }
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
        cv.delegate = self
        cv.register(DropDownMenuCell.self, forCellWithReuseIdentifier: DropDownMenuCell.identifier)
        return cv
    }()
    
    lazy var collectionViewDataSource = makeDataSource()
    
    init(titles: [String]) {
        super.init(frame: .zero)
        self.titles = titles
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupConstraint()
        
        //set up collectionView
        collectionView.dataSource = collectionViewDataSource
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
extension DropDownMenuView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < titleModelDataSource.count else { return }
        didSelectItemHandler?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = floor(collectionView.bounds.width / CGFloat(rowCellCount))
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - CollectionView DiffableDataSource
extension DropDownMenuView {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<menuTypeSection, DropDownMenuCellModel> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropDownMenuCell.identifier, for: indexPath) as! DropDownMenuCell
            cell.titleLabel.text = item.title
            cell.isCellSelected = item.isCellSelected
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<menuTypeSection, DropDownMenuCellModel>()
        snapshot.appendSections([.first])
        snapshot.appendItems(self.titleModelDataSource, toSection: .first)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}
