//
//  MatchedView.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2019/1/15.
//  Copyright © 2019 haoyuan tan. All rights reserved.
//

import UIKit
import Firebase
class MatchedView: UIView {
    
    var currentUser : User!{
        didSet{

        }
    }
    var cardUID: String! {
        didSet{
            let query = Firestore.firestore().collection("users")
            query.document(cardUID).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                guard let dictionary = snapshot?.data() else {return}
                let user = User(dictionary: dictionary)
                guard let url = URL(string: user.imageUrl1 ?? "") else {return}
                self.currentUserImageView2.sd_setImage(with: url)
                self.descriptionLabel.text = "You and \(user.name ?? "") have liked\neach other"
                guard let currentUserImageUrl = URL(string: self.currentUser.imageUrl1 ?? "") else {return}
                self.currentUserImageView.sd_setImage(with: currentUserImageUrl, completed: { (_, _, _, _) in
                    self.setUpAnimations()
                })
                


            }
        }
    
    }
    
    fileprivate let itsAMatchImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "未命名作品 18"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate let descriptionLabel : UILabel = {
        let label = UILabel()
//        label.text = "You and x have liked\neach other"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    fileprivate let currentUserImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "_10A6254"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 70
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    fileprivate let currentUserImageView2 : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "_MG_7331"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 70
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.alpha = 0
        return iv
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.backgroundColor = .yellow
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBlurView()
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setUpAnimations(){
        views.forEach({$0.alpha = 1})
        // starting position
        let angel = 15 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: angel).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        currentUserImageView2.transform = CGAffineTransform(rotationAngle: -angel).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//            self.currentUserImageView.transform = .identity
//            self.currentUserImageView2.transform = .identity
//        }) { (_) in
//
//        }
        
        //keyframe animations for segmented animation
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            //animation 1 - translation bake to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: angel)
                self.currentUserImageView2.transform = CGAffineTransform(rotationAngle: -angel)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
                self.currentUserImageView2.transform = .identity
            })

        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.75, delay: 0.65 , usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        })
    }
    lazy var views = [
        itsAMatchImageView,
        descriptionLabel,
        currentUserImageView,
        currentUserImageView2,
        sendMessageButton,
        keepSwipingButton
    ]
    fileprivate func setUpLayout(){

        
        views.forEach { (view) in
            addSubview(view)
            view.alpha = 0
        }
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 60))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        

        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 140, height: 140))
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        currentUserImageView2.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        currentUserImageView2.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60) )
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate func setUpBlurView(){
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        visualEffectView.alpha = 0
        addSubview(visualEffectView)
        
        visualEffectView.fillSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
    
        }
    }
    @objc fileprivate func handleTapDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()

        }
    }
    
    

}
