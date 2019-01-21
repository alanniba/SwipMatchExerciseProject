//
//  UserInfoViewController.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/26.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController , UIScrollViewDelegate {

    var cardViewModel : CardViewModel! {
        didSet{
            userInfoLab.attributedText = cardViewModel.attributedString
            swipingController.cardViewModel = cardViewModel
        }
    }
    
    lazy var dislikeBut = self.createButton(image: #imageLiteral(resourceName: "Image-1"), selector: #selector(handleDislike))
    lazy var superlikeBut = self.createButton(image: #imageLiteral(resourceName: "Image-2"), selector: #selector(handleDislike))
    lazy var likeBut = self.createButton(image: #imageLiteral(resourceName: "Image-3"), selector: #selector(handleDislike))

    @objc fileprivate func handleDislike(){
        
    }
    fileprivate func createButton(image: UIImage, selector : Selector) -> UIButton{
        let but = UIButton(type: .system)
        but.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        but.addTarget(self, action: selector, for: .touchUpInside)
        but.imageView?.contentMode = .scaleAspectFill
        return but
    }
    lazy var scrollV: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    let dismissBut: UIButton = {
        let but = UIButton(type: .system)
        but.setImage(#imageLiteral(resourceName: "1ce781c2-3d5a-4adb-a21e-63947fe0af50").withRenderingMode(.alwaysOriginal), for: .normal)
        but.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return but
    }()
//    let userImageView : UIImageView = {
//        let iv = UIImageView(image: #imageLiteral(resourceName: "_10A6245"))
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        return iv
//    }()
    let swipingController = SwipingPhotosController(isCardViewMode: false)
    
    let userInfoLab : UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.text = "Alan 30\nprofession\nbio desicription"
        return lab
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControls()
    }
    
    fileprivate func setupBottomControls(){
        let stackView = UIStackView(arrangedSubviews: [dislikeBut, superlikeBut , likeBut])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.spacing = -32
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupVisualBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
//        visualEffectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 24)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func handleDismiss(gesture: UIPanGestureRecognizer){
        dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let valueY = -scrollView.contentOffset.y
        let userImageView = swipingController.view!

        if valueY > 0 {
            userImageView.frame = CGRect(x: -valueY, y: -valueY, width: self.view.frame.width + valueY * 2, height: self.view.frame.width + valueY * 2 + 80)

        }
    }
    override func viewWillLayoutSubviews() {
        let userImageView = swipingController.view!
        userImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 80)

    }

    fileprivate func setupLayout() {
        self.view.addSubview(scrollV)
        scrollV.fillSuperview()
        let swipingView = swipingController.view!
        
        scrollV.addSubview(swipingView)
        
        scrollV.addSubview(userInfoLab)
        userInfoLab.anchor(top: swipingView.bottomAnchor, leading: scrollV.leadingAnchor, bottom: nil, trailing: scrollV.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollV.addSubview(dismissBut)
        dismissBut.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 40), size: .init(width: 50, height: 50))
    }

}
