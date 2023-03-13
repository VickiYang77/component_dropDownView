//
//  AlwaysShowPopup.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/7.
//

import UIKit

@objc class AlwaysPresentAsPopover: NSObject, UIPopoverPresentationControllerDelegate {
    
    // because the delegate property is weak - the delegate instance needs to be retained
    
    static let sharedInstance = AlwaysPresentAsPopover()
    var dismissHandler:(()->Void)?
    
    private override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func configurePresentation(forController controller : UIViewController, dismiss handler:@escaping (()->Void)) -> UIPopoverPresentationController {
        
        // 以 popover 的效果呈現
        controller.modalPresentationStyle = .popover
        
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        
        presentationController.delegate = AlwaysPresentAsPopover.sharedInstance
        AlwaysPresentAsPopover.sharedInstance.dismissHandler = handler
        return presentationController
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        guard let dismissHandler = dismissHandler else { return true }
        dismissHandler()
        return true
    }
}
/*
extension UIViewController {

    /**
     - parameter controller: 要被 Popup 的 ViewController
     - parameter sourceView: 被點擊的物件
     - parameter isfromBarButton: 被點擊的物件是否為 UIBarButtonItem
     - parameter arrowDirections: popover 的箭頭方向
     - parameter sourceRectNeedConvert: 為被點擊物件為 self.view's subView 的 subView，需轉換相對於 UIViewController's view 的座標系統的位置
     */
    func popup(_ controller: UIViewController, sourceView: UIView, isfromBarButton: Bool, arrowDirections: UIPopoverArrowDirection, sourceRectNeedConvert: Bool) {
        
        let shadowView = UIView(frame: self.view.bounds)
        shadowView.alpha = 0.5
        shadowView.backgroundColor = .black
      
        let presentationController = AlwaysPresentAsPopover.sharedInstance.configurePresentation(forController: controller, dismiss:{ [weak shadowView] in
            shadowView?.removeFromSuperview()
        })
        //為了弄黑後面畫面
//        self.view.addSubview(shadowView)
        
        presentationController.backgroundColor = controller.view.backgroundColor
        presentationController.permittedArrowDirections = arrowDirections
        presentationController.popoverBackgroundViewClass = DropDownMenuNoArrowPopoverBackgroundView.self
//        presentationController.popoverLayoutMargins = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        if sourceRectNeedConvert {
            let sourceRect = sourceView.convert(CGRect(x: sourceView.bounds.origin.x,
                                                       y: sourceView.bounds.origin.y,
                                                       width: sourceView.bounds.size.width,
                                                       height: sourceView.bounds.size.height), to: self.view)
            presentationController.sourceView = self.view
            presentationController.sourceRect = sourceRect
        } else {
            presentationController.sourceView = sourceView
            presentationController.sourceRect = sourceView.bounds
        }
        
        if isfromBarButton {
            presentationController.barButtonItem = UIBarButtonItem(customView: sourceView)
        }
        self.present(controller, animated: true)
    }
}
*/
