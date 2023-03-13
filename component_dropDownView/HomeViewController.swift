//
//  HomeViewController.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/2.
//

import UIKit

class HomeViewController: UIViewController {
    let viewControllers: [UIViewController] = [Test1VC(), Test2VC(), Test3VC(), Test4VC(), Test5VC(), Test6VC(), Test7VC(), Test8VC(), Test9VC(), Test10VC()]
    let titles = ["群組一群組一", "群組二", "群組三", "群組四", "群組五" ,"群組六", "群組七", "群組八", "群組九", "群組十"]
    
    lazy var selectedViewController: UIViewController = viewControllers[0]
    
    lazy var navbarView: NavBarMenuView = {
        let view = NavBarMenuView(titles: self.titles, sourceView: self.view)
        return view
    }()
    
    var containerGroupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
        navbarView.selectedIndex = 0
    }
    
    private func setupUI() {
        self.navigationItem.titleView = navbarView
        view.addSubview(containerGroupView)
        NSLayoutConstraint.activate([
            containerGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            containerGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerGroupView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerGroupView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func binding() {
        navbarView.changeMenuHandler = { [weak self] index in
            guard let self = self else { return }
            
            self.hideContainerController(vc: self.selectedViewController)
            let vc = self.viewControllers[index]
            self.selectedViewController = vc
            self.showContainerController(vc: vc)
        }
    }

// MARK: - show / hide container controller
    func showContainerController(vc: UIViewController) {
        self.addChild(vc)
        self.containerGroupView.addSubview(vc.view)
        vc.didMove(toParent: self)
        self.selectedViewController = vc
    }
    
    func hideContainerController(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}

// MARK: - test controller
class Test1VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group1"
        view.backgroundColor = .red
    }
}

class Test2VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group2"
        view.backgroundColor = .orange
    }
    
}

class Test3VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group3"
        view.backgroundColor = .yellow
    }
}

class Test4VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group4"
        view.backgroundColor = .green
    }
}

class Test5VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group5"
        view.backgroundColor = .cyan
    }
}

class Test6VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group6"
        view.backgroundColor = .blue
    }
}

class Test7VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group7"
        view.backgroundColor = .purple
    }
}

class Test8VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group8"
        view.backgroundColor = .brown
    }
}

class Test9VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group9"
        view.backgroundColor = .gray
    }
}

class Test10VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group10"
        view.backgroundColor = .white
    }
}
