//
//  SwipingPhotosController.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2019/1/1.
//  Copyright © 2019 haoyuan tan. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet{
            print(cardViewModel.attributedString)
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
            let photoVC = PhotoController(imageUrl: imageUrl)
            return photoVC
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            setupBarView()
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}){
            stackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            stackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
    

    var stackView  = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    fileprivate func setupBarView() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.layer.cornerRadius = 2
            barView.backgroundColor = deselectedBarColor
            stackView.addArrangedSubview(barView)
        }
        view.addSubview(stackView)
        stackView.arrangedSubviews.first?.backgroundColor = .white
        
        var paddingTop: CGFloat = 8
        if !isCardViewModel {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }
        
        
        stackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 4, bottom: 0, right: 4), size: .init(width: 0, height: 4))
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
    }
    
    var controllers = [UIViewController]()

    fileprivate let isCardViewModel : Bool
    
    init(isCardViewMode : Bool = false) {
        self.isCardViewModel = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        dataSource = self
        delegate = self
        let redviewController = UIViewController()
        redviewController.view.backgroundColor = .red
        
        if isCardViewModel {
            disableSwipingAbility()
        }
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture : UITapGestureRecognizer){
        let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController){
            stackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})

            if gesture.location(in: self.view).x > view.frame.width/2{
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextCOntroller = controllers[nextIndex]
                setViewControllers([nextCOntroller], direction: .forward, animated: false)
                stackView.arrangedSubviews[nextIndex].backgroundColor = .white

            } else {
                let lastIndex = max(0, index - 1)
                let lastController = controllers[lastIndex]
                setViewControllers([lastController], direction: .reverse, animated: false)
                stackView.arrangedSubviews[lastIndex].backgroundColor = .white
            }
        }
    }
    
    fileprivate func disableSwipingAbility(){
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView{
                v.isScrollEnabled = false
            }
        }
    }

}

class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "_10A6245"))

    init(imageUrl: String) {
        if let imageUrl = URL(string: imageUrl) {
            imageView.sd_setImage(with: imageUrl)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        
    }
}
