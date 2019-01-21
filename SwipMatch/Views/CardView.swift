//
//  CardView.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/11/30.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapInfoBut(cardViewModel : CardViewModel)
    func didRemoveCardView(cardView: CardView)
    func didSwipToLike()
    func didSwipToDislike()

}
class CardView: UIView {
    var nextCardView: CardView?
    var delegate : CardViewDelegate?
    fileprivate var infoBut : UIButton = {
        let but = UIButton(type: .system)
        but.setImage(#imageLiteral(resourceName: "info").withRenderingMode(.alwaysOriginal), for: .normal)
        but.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        return but
    }()
    
    @objc fileprivate func handleInfo (){
        delegate?.didTapInfoBut(cardViewModel: self.cardViewModel)
    }
    
    var cardViewModel : CardViewModel! {
        didSet{
            swipingPhotosController.cardViewModel = self.cardViewModel
            informationLab.attributedText = cardViewModel.attributedString
            informationLab.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count ).forEach { (_) in
                let testView = UIView()
                
                testView.backgroundColor = topBarBGColor
                topStackView.addArrangedSubview(testView)
            }
            topStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = { [unowned self] (idx , imageUrl) in
            print("Changing Photo")
            self.topStackView.arrangedSubviews.forEach({ (view) in
                view.backgroundColor = self.topBarBGColor
            })
            self.topStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
    //MARK:- Confagirations
    //encapsulation
    fileprivate let threshold : CGFloat = 80
    fileprivate let gradientLayer = CAGradientLayer()
//    fileprivate let imageView = UIImageView(image: UIImage(named: "_MG_7331"))
    fileprivate let informationLab = UILabel()
    fileprivate let topBarBGColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
//    var imageIndex = 0
    @objc fileprivate func handleTap(gesture : UITapGestureRecognizer){
        let shouldChangeImage = gesture.location(in: nil).x > self.frame.width/2 ? true : false

        if shouldChangeImage{
            cardViewModel.toNextPhoto()
        } else {
            cardViewModel.toLastPhoto()
        }
//        if shouldChangeImage{
//
//            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1 )
//        } else {
//            imageIndex = max(0, imageIndex - 1)
//        }
//
//        imageView.image = UIImage(named: cardViewModel.imageNames[imageIndex])
//
//        topStackView.arrangedSubviews.forEach { (view) in
//            view.backgroundColor = topBarBGColor
//        }
//        topStackView.arrangedSubviews[imageIndex].backgroundColor = .white
//
    }
    
    fileprivate func setLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
        
        
        let swipingPhotoView = swipingPhotosController.view!
        addSubview(swipingPhotoView)

        swipingPhotoView.fillSuperview()

        setupGradientLayer()
//        setupTopStackBarView()
        addSubview(informationLab)
        informationLab.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLab.textColor = .white
        informationLab.numberOfLines = 0
        informationLab.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        addSubview(infoBut)
        infoBut.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 24, right: 12), size: .init(width: 36, height: 36))
    }
    
    fileprivate let topStackView = UIStackView()
    fileprivate func setupTopStackBarView() {
        //add a horizontal view
        topStackView.distribution = .fillEqually
        topStackView.spacing = 4
        
        addSubview(topStackView)
        topStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
 
    }

    fileprivate func setupGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor , UIColor.black.cgColor]
        gradientLayer.locations = [ 0.5 , 1.1 ]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        // in here we know that cardView frame will be
        gradientLayer.frame = self.frame
    }
    
    @objc func handlePan(gesture : UIPanGestureRecognizer){
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleTheChange(gesture)

        case .ended:
            handleTheEnd(gesture)
            
        default:
            ()
        }
    }
    
    fileprivate func handleTheEnd(_ gesture : UIPanGestureRecognizer) {
        let translationDirection : CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismiss = gesture.translation(in: nil).x > threshold || gesture.translation(in: nil).x < -threshold
        
        //hack solution
        
        if shouldDismiss{
            guard let homeController = self.delegate as? HomeController else { return}
            if translationDirection == 1{
                homeController.handleLike()
//                delegate?.didSwipToLike()
            } else {
                homeController.handleDisLike()
//                delegate?.didSwipToDislike()
                
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }

    }
    
    fileprivate func handleTheChange(_ gesture: UIPanGestureRecognizer) {
        let transformValue = gesture.translation(in: nil)
        let degress:Float = Float(transformValue.x)/20
        let angle = degress * Float.pi / 180
        let rotaionalTransformation = CGAffineTransform(rotationAngle: CGFloat(angle)).translatedBy(x: transformValue.x, y: transformValue.y)
        self.transform = rotaionalTransformation
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
