//
//  NavBarMenuContainerView.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/10.
//

import UIKit

class NavBarMenuContainerView: UIView {
    var titleDataSource: [String] = [] {
        didSet {
            dropDownMenuView.titleDataSource = titleDataSource
            selectedIndex = 0
        }
    }
    
    lazy var selectedIndex = 0 {
        didSet {
            dropDownMenuView.selectedIndex = selectedIndex
        }
    }
    var hideMenuHandler: (() -> ())?
    
    /// 設定 dropDownMenu 屬性
    var didSelectMenuHandler: ((Int) -> ())?    // 點擊選單項目
    var dropDownMenuCellInRowCount = 3
    var dropDownMenuCellHeight: CGFloat = 50
    var dropDownMenuBackgroundColor: UIColor = .black {
        didSet {
            dropDownMenuView.dropDownMenuBackgroundColor = dropDownMenuBackgroundColor
        }
    }
    var dropDownMenuWithShadow = true {
        didSet {
            backgroundColor = dropDownMenuWithShadow ? .black.withAlphaComponent(0.5) : .clear
        }
    }
    
    private var dropDownMenuHeight: CGFloat {
        let rowCount = ceil(CGFloat(self.titleDataSource.count)/CGFloat(self.dropDownMenuCellInRowCount))
        return self.dropDownMenuCellHeight * rowCount
    }
    
    lazy var dropDownMenuView: DropDownMenuView = {
        let view = DropDownMenuView(titles: self.titleDataSource)
        view.selectedIndex = self.selectedIndex
        view.cellHeight = self.dropDownMenuCellHeight
        view.dropDownMenuBackgroundColor = self.dropDownMenuBackgroundColor
        view.didSelectItemHandler = { [weak self] indexPath in
            self?.selectedIndex = indexPath.row
            self?.didSelectMenuHandler?(indexPath.row)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(titles: [String]) {
        super.init(frame: .zero)
        self.titleDataSource = titles
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupConstraint()
    }
    
    private func setupConstraint() {
        addSubview(dropDownMenuView)
        NSLayoutConstraint.activate([
            dropDownMenuView.topAnchor.constraint(equalTo: self.topAnchor),
            dropDownMenuView.leftAnchor.constraint(equalTo: self.leftAnchor),
            dropDownMenuView.rightAnchor.constraint(equalTo: self.rightAnchor),
            dropDownMenuView.heightAnchor.constraint(equalToConstant: dropDownMenuHeight)
        ])
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if point.y > 0 {
            let pointForView = self.convert(point, to: self)
            if !dropDownMenuView.bounds.contains(pointForView) && self.bounds.contains(pointForView) {
                hideMenuHandler?()
            }
        }

        return super.hitTest(point, with: event)
    }
}
