//
//  NavBarMenuView.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/6.
//

import UIKit

class NavBarMenuView: UIView {
    var sourceView: UIView?
    var titleDataSource: [String] = [] {
        didSet {
            selectedIndex = 0
        }
    }
    
    lazy var selectedIndex = 0 {
        didSet {
            if self.titleDataSource.count > 0 {
                if selectedIndex < 0 {
                    selectedIndex = self.titleDataSource.count - 1
                } else if selectedIndex >= self.titleDataSource.count {
                    selectedIndex = 0
                }
            
                self.titleLabel.text = self.titleDataSource[selectedIndex]
                self.changeMenuHandler?(selectedIndex)
                self.containerView.selectedIndex = selectedIndex
            }
        }
    }
    
    // 切換選單項目
    var changeMenuHandler: ((Int) -> ())?
    
    /// 設定 dropDownMenu 屬性
    var dropDownMenuCellInRowCount = 3  // 一列多少個Cell
    var dropDownMenuCellHeight: CGFloat = 50
    var dropDownMenuWithShadow = false
    var dropDownMenuBackgroundColor: UIColor = .black {
        didSet {
            containerView.dropDownMenuBackgroundColor = dropDownMenuBackgroundColor
        }
    }
    private var dropDownMenuIsShow = false {
        didSet {
            let imageString = dropDownMenuIsShow ? "bk_icon_arrow_up_solid_12_p" : "bk_icon_arrow_down_solid_12_p"
            downArrowImage.image = UIImage(named: imageString)
        }
    }
    
    // MARK: - 測試用參數 測完可移除
    var sourceVC: UIViewController?
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.5
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        lbl.isUserInteractionEnabled = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var leftArrowBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "b_icon_trendleft_gray")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = .white
        btn.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var rightArrowBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "b_icon_trendright_gray")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = .white
        btn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var downArrowImage: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "bk_icon_arrow_down_solid_12_p"))
        imgView.isUserInteractionEnabled = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var containerView: NavBarMenuContainerView = {
        let view = NavBarMenuContainerView(titles: titleDataSource)
        view.dropDownMenuCellInRowCount = self.dropDownMenuCellInRowCount
        view.dropDownMenuCellHeight = self.dropDownMenuCellHeight
        view.dropDownMenuWithShadow = self.dropDownMenuWithShadow
        view.dropDownMenuBackgroundColor = self.dropDownMenuBackgroundColor
        view.hideMenuHandler = { [weak self] in
            self?.removeContainerView()
        }
        view.didSelectMenuHandler = { [weak self] index in
            guard let self = self else { return }
            self.selectedIndex = index
            self.removeContainerView()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    init(titles: [String], sourceView: UIView) {
        super.init(frame: .zero)
        self.titleDataSource = titles
        self.sourceView = sourceView
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        setupConstraint()
    }
    
    // MARK: - Setup Constraint
    func setupConstraint() {
        let centerStackView = UIStackView(arrangedSubviews: [titleLabel, downArrowImage])
        centerStackView.axis = .vertical
        centerStackView.distribution = .fill
        centerStackView.alignment = .center
        centerStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDownMenu)))
        addSubview(centerStackView)
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerStackView.topAnchor.constraint(equalTo: topAnchor),
            centerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            downArrowImage.widthAnchor.constraint(equalToConstant: 12),
            downArrowImage.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        addSubview(leftArrowBtn)
        NSLayoutConstraint.activate([
            leftArrowBtn.widthAnchor.constraint(equalToConstant: 40),
            leftArrowBtn.heightAnchor.constraint(equalToConstant: 40),
            leftArrowBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftArrowBtn.rightAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ])
        
        addSubview(rightArrowBtn)
        NSLayoutConstraint.activate([
            rightArrowBtn.widthAnchor.constraint(equalToConstant: 40),
            rightArrowBtn.heightAnchor.constraint(equalToConstant: 40),
            rightArrowBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrowBtn.leftAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
    }
    
    // MARK: - Button Event
    @objc func leftBtnTapped() {
        removeContainerView()
        selectedIndex -= 1
    }
    
    @objc func rightBtnTapped() {
        removeContainerView()
        selectedIndex += 1
    }
    
    @objc func showDropDownMenu() {
        if let sourceView = sourceView {
            dropDownMenuIsShow = !dropDownMenuIsShow
            if dropDownMenuIsShow {
                sourceView.addSubview(containerView)
                sourceView.bringSubviewToFront(containerView)
                NSLayoutConstraint.activate([
                    containerView.topAnchor.constraint(equalTo: self.bottomAnchor),
                    containerView.bottomAnchor.constraint(equalTo: sourceView.bottomAnchor),
                    containerView.leftAnchor.constraint(equalTo: sourceView.leftAnchor),
                    containerView.rightAnchor.constraint(equalTo: sourceView.rightAnchor)
                ])
            } else {
                removeContainerView()
            }
        }
    }
    
    private func removeContainerView() {
        containerView.removeFromSuperview()
        dropDownMenuIsShow = false
    }
    
    // UIControl的物件可以直接 add 到 titleView 中，但 UIView 的物件就要覆寫 intrinsicContentSize 才能 enable 點擊事件
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}

// MARK: - popover 版本
/*
extension NavBarMenuView {
    
    @objc func showDropDownMenu2() {
        if let sourceVC = sourceVC {
            let popVC = DropDownMenuViewController()
            popVC.titleDataSource = self.titleDataSource
            popVC.selectedIndex = self.selectedIndex
            popVC.cellHeight = self.dropDownMenuCellHeight
            popVC.didSelectItemHandler = { [weak self] indexPath in
                self?.selectedIndex = indexPath.row
            }
            
            popVC.modalPresentationStyle = .popover
            popVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: dropDownMenuHeight)
            
            let shadowView = UIView(frame: sourceVC.view.bounds)
            shadowView.alpha = 0.5
            shadowView.backgroundColor = .black
            if dropDownMenuWithShadow {
                sourceVC.view.addSubview(shadowView)
            }
            
            let popoverController = AlwaysPresentAsPopover.sharedInstance.configurePresentation(forController: popVC, dismiss:{ [weak shadowView] in
                shadowView?.removeFromSuperview()
            })
            
            popoverController.sourceView = self
            popoverController.sourceRect = CGRect(origin: .zero, size: self.frame.size)
            popoverController.popoverLayoutMargins = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
            popoverController.backgroundColor = sourceView?.backgroundColor
//            popoverController.permittedArrowDirections = .any//[.init(rawValue: 0)]
//            popoverController.popoverBackgroundViewClass = DropDownMenuNoArrowPopoverBackgroundView.self
            sourceVC.present(popVC, animated: true)
        }
    }
}
*/
