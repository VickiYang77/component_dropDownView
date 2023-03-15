//
//  ViewController.swift
//  component_dropDownView
//
//  Created by 金融研發一部-楊雅婷 on 2023/3/1.
//

import UIKit

class ViewController: UIViewController {
    let viewControllers: [UIViewController] = [Test1VC(), Test2VC(), Test3VC(), Test4VC(), Test5VC(), Test6VC(), Test7VC(), Test8VC(), Test9VC(), Test10VC()]
    let titles = ["群組一群組一", "群組二", "群組三", "群組四", "群組五" ,"群組六", "群組七", "群組八", "群組九", "群組十"]
    
    lazy var selectedViewController: UIViewController = viewControllers[0]
    
    @IBOutlet weak var navbarView: NavBarMenuView!
    @IBOutlet weak var homePageBtn: UIButton!
    
    lazy var navbarView2: NavBarMenuView = {
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
        navbarView2.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setupUI() {
        navbarView.backgroundColor = .gray
        view.addSubview(containerGroupView)
        NSLayoutConstraint.activate([
            containerGroupView.topAnchor.constraint(equalTo: navbarView.bottomAnchor),
            containerGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerGroupView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerGroupView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        self.navigationItem.titleView = navbarView2
        navbarView2.backgroundColor = .lightGray
    }
    
    private func binding() {
        navbarView.titleDataSource = titles
        navbarView.sourceView = self.view
        navbarView.changeMenuHandler = { [weak self] index in
            guard let self = self else { return }

            self.hideContainerController(vc: self.selectedViewController)
            let vc = self.viewControllers[index]
            self.selectedViewController = vc
            self.showContainerController(vc: vc)
        }
        
        navbarView2.changeMenuHandler = { [weak self] index in
            guard let self = self else { return }
            
            self.hideContainerController(vc: self.selectedViewController)
            let vc = self.viewControllers[index]
            self.selectedViewController = vc
            self.showContainerController(vc: vc)
        }
    }
    
    // MARK: - Button Event
    @IBAction func didTapHomePageBtn(_ sender: Any) {
        let vc = HomeViewController()
        self.navigationController?.navigationBar.backgroundColor = .darkGray
        self.navigationController?.pushViewController(vc, animated: true)
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

