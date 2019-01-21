//
//  ViewController.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/11/29.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD



extension HomeController: savedUserInfoDelegate{
    func savedUserInfo() {
        fetchCurrentUser()
    }
    

}
class HomeController: UIViewController , LoginControllerDelegate, CardViewDelegate {

    

    

    
    func didTapInfoBut(cardViewModel: CardViewModel) {
        print(cardViewModel.attributedString)
        let toVC = UserInfoViewController()
        toVC.cardViewModel = cardViewModel
        present(toVC, animated: true)
    }
    
    let topStackView = HomeTopBottomsUIStackView()
    let botStackView = HomeBottomsUIStackView()
    let cardsDeskView = UIView()

    
//    let cardViewModels : [CardViewModel] = {
//        let producer = [
//            User(name: "Alan", age: 25, profession: "iOS Developer", imageNames: ["_10A6250","_10A6228","_10A6229"]),
//            User(name: "Brenda", age: 20, profession: "Aynaliser", imageNames: ["_10A6254","_10A6252","_10A6250"]),
//            Advertiser(title: "wdf company", brandName: "this is an advertiser", posterPhotoName: "_10A6255")
//        ] as [ProducesCardViewModel]
//        let viewModels = producer.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        botStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        botStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        botStackView.dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        
        
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil{
            let loginVC = LoginController()
            loginVC.delegate = self
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            present(navigationController, animated: true)
        }
    }
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    
    @objc fileprivate func handleRefresh(){
//        if topCardView == nil{
//            fetchUserFromFirestore()
//        }
        cardsDeskView.subviews.forEach({$0.removeFromSuperview()})
        fetchUserFromFirestore()
    }
    
    
    var currentUser : User?
    fileprivate func fetchCurrentUser (){        
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print(err)
                return
            }
            self.currentUser = user
            self.fetchSwips()
//            self.fetchUserFromFirestore()
        }
    }
    
    var swips = [String : Int]()
    fileprivate func fetchSwips(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swips").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            print("swips:", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else {return}
            self.swips = data
            self.fetchUserFromFirestore()
        }
    }
    
//    var lastfetchedUser : User?
    fileprivate func fetchUserFromFirestore(){
        let hud = JGProgressHUD(style: .dark)
        let minAge = self.currentUser?.minSeekingAge ?? 18
        let maxAge = self.currentUser?.maxSeekingAge ?? 50
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print(err)
                return
            }
            // set up nextcard view
            
            var preivousCardView: CardView?
            snapshot?.documents.forEach({ (docSnapshot) in
                let userdic = docSnapshot.data()
                let user = User(dictionary: userdic)
                if user.uid != Auth.auth().currentUser?.uid{
                    let cardView = self.setupCardFromUser(user: user)
                    
                    
                    preivousCardView?.nextCardView = cardView
                    preivousCardView = cardView
                    if self.topCardView == nil{
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeskView.addSubview(cardView)
        cardsDeskView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    @objc fileprivate func handleSetting(){
        let settingVC = SettingTableViewController()
        settingVC.delegate = self
        let navController = UINavigationController(rootViewController: settingVC)
        present(navController, animated: true)
    }
    
    
    
    //MARK:- setup view
    fileprivate func layoutView() {
        self.view.backgroundColor = .white
//        let emptyLab = UILabel()
//        emptyLab.text = "点击刷新来从心加载数据🙃"
//        emptyLab.textAlignment = .center
//        emptyLab.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        self.view.addSubview(emptyLab)
//        emptyLab.fillSuperview()
        
        let  imageHolder = UIImageView(image: #imageLiteral(resourceName: "未命名作品 19"))
        imageHolder.contentMode = .scaleAspectFill
        self.view.addSubview(imageHolder)
        imageHolder.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 100, left: 40, bottom: 100, right: 40))
        
        let overAllStackView = UIStackView(arrangedSubviews: [topStackView , cardsDeskView, botStackView])
        overAllStackView.axis = .vertical
        self.view.addSubview(overAllStackView)
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overAllStackView.bringSubviewToFront(cardsDeskView)
    }
    
    fileprivate func setupFirestoreuserCards(){
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeskView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    
    var topCardView: CardView?
    @objc func handleLike(){
        prefomeSwipAnimation(transation: 700, angle: 15)
        saveSwipToFirestore(didLike: 1)

    }
    
    func didRemoveCardView(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    @objc func handleDisLike(){
        prefomeSwipAnimation(transation: -700, angle: -15)
        saveSwipToFirestore(didLike: 0)

    }
    
    fileprivate func prefomeSwipAnimation(transation: CGFloat , angle : CGFloat){
        let duration = 0.45
        let transationAnimation = CABasicAnimation(keyPath: "position.x")
        transationAnimation.toValue = transation
        transationAnimation.duration = duration
        transationAnimation.fillMode = .forwards
        transationAnimation.isRemovedOnCompletion = false
        transationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotaionAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotaionAnimation.toValue = angle * CGFloat.pi / 180
        rotaionAnimation.duration = duration
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(transationAnimation, forKey: "transation")
        cardView?.layer.add(rotaionAnimation, forKey: "rotation")
        CATransaction.commit()

    }
    
    fileprivate func saveSwipToFirestore(didLike : Int){
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        guard  let cardUID = topCardView?.cardViewModel.uid else {return}
    
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swips").document(uid).getDocument { (snapShot, err) in
            if let err = err {
                print(err)
                return
            }
            
            
            if snapShot?.exists == true{
                Firestore.firestore().collection("swips").document(uid).updateData(documentData) { (err) in
                    if let err = err{
                        print(err)
                        return
                    }
                    print("success")
                    if didLike == 1{
                        self.checkIfMatchExists(cardUID: cardUID)
                        
                    }
                }
            } else {
                Firestore.firestore().collection("swips").document(uid).setData(documentData) { (err) in
                    if let err = err{
                        print(err)
                        return
                    }
                    print("success")
                    if didLike == 1{
                        self.checkIfMatchExists(cardUID: cardUID)
                        
                    }
                    
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String){
        print("detect if match")
        Firestore.firestore().collection("swips").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }

            guard let data = snapshot?.data() else {return}
            print(data)
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let hasMatched = data[uid] as? Int == 1
            if hasMatched{

                self.presentMatchView(cardUID: cardUID)
            }
            
            
        }
    }
    
    fileprivate func presentMatchView(cardUID : String){
        let matchView = MatchedView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.currentUser
        view.addSubview(matchView)
        matchView.fillSuperview()
        
    }
    
    func didSwipToLike() {
        handleLike()
    }
    
    func didSwipToDislike() {
        handleDisLike()
    }



}

