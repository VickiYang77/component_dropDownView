//
//  DropDownMenuNoArrowPopoverBackgroundView.swift
//  MyCombineTest
//
//  Created by 金融研發一部-黃建凱 on 2022/8/5.
//

import UIKit

/**
 客製化Popover無箭頭，只需指定popoverBackgroundViewClass即可
 
 使用方式如下
 
 ```
 presentationController.popoverBackgroundViewClass = DropDownMenuNoArrowPopoverBackgroundView.self
 ```
 */
class DropDownMenuNoArrowPopoverBackgroundView: UIPopoverBackgroundView {
    
    private var arrOffset: CGFloat
    private var arrDirection: UIPopoverArrowDirection
    
    override init(frame: CGRect) {
        self.arrOffset = 0.0
        self.arrDirection = .init(rawValue: 0)
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        // corner
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
    }

    override class func arrowHeight() -> CGFloat {
        return 0.0
    }

    override class func arrowBase() -> CGFloat {
        return 0.0
    }

    override var arrowOffset: CGFloat {
        get {
            return self.arrOffset
        }
        set {
            self.arrOffset = newValue
        }
    }

    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return self.arrDirection
        }
        set {
            self.arrDirection = newValue
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
