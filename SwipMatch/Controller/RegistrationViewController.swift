//
//  RegistrationViewController.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/6.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
//        registrationViewModel.userImage = image
        registrationViewModel.checkFormValidity()
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

class RegistrationViewController: UIViewController {

    //MARK:- UI elements
    let selectPhotoBut : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 270).isActive = true
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
        return button
    }()
    
    let fullNameTextFeild : CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextFeild : CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return tf
    }()
    
    let passwordTextFeild : CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField){
        if textField == fullNameTextFeild{
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextFeild{
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
        

    }
    
    let registorButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.backgroundColor = .lightGray
        button.setTitleColor(.darkGray, for: .disabled)
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitle("Rigsiter", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister(){
        self.handleTapDismiss()

        registrationViewModel.proformRegistration { (err) in
            if let err = err {
                self.showHUDWithError(err: err)
                return
            }
            print("Finished registrating our user")
        }
    }

    func showHUDWithError (err : Error){
        registeringHUD.dismiss()
        let hud = JGProgressHUD.init(style: .extraLight)
        hud.textLabel.text = "Feild register"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrandiantLayer()
        
        setupLayout()
        setupNotificationObervations()
        setupTabGesture()
        
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    //MARK:- Private
    
    @objc fileprivate func handleImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver(){
        registrationViewModel.bindableIsFormValid.bind {[unowned self] (isValid) in
            guard let isValid = isValid else {return}
            if isValid{
                self.registorButton.backgroundColor = #colorLiteral(red: 0.8261713386, green: 0.09696670622, blue: 0.3260518909, alpha: 1)
                self.registorButton.setTitleColor(.white, for: .normal)
                self.registorButton.isEnabled = true
            } else {
                self.registorButton.backgroundColor = .lightGray
                self.registorButton.setTitleColor(.gray, for: .disabled)
                self.registorButton.isEnabled = false
            }
        }
        registrationViewModel.bindableImage.bind {[unowned self] (img) in
            self.selectPhotoBut.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { (isRegistering) in
            if isRegistering == true{
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
        
//        registrationViewModel.isFormValidObserver = {[unowned self] (isFormValid) in
//            self.registorButton.isEnabled = isFormValid
//            if isFormValid{
//                self.registorButton.backgroundColor = #colorLiteral(red: 0.8261713386, green: 0.09696670622, blue: 0.3260518909, alpha: 1)
//                self.registorButton.setTitleColor(.white, for: .normal)
//            } else {
//                self.registorButton.backgroundColor = .lightGray
//                self.registorButton.setTitleColor(.gray, for: .disabled)
//            }
//        }

//        registrationViewModel.imageOberver = {[unowned self] img in
//            self.selectPhotoBut.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
    }
    
    
    fileprivate func setupTabGesture(){
        let gestrue = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        self.view.addGestureRecognizer(gestrue)
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)
 
    }
    
    fileprivate func setupNotificationObervations(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboarDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboarDismiss(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.transform = .identity
            })
        })

    }
    
    @objc fileprivate func handleKeyboardShow(notification : Notification){
        guard  let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = self.view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }
    
    let grandiantLayer = CAGradientLayer()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        grandiantLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact{
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    fileprivate func setupGrandiantLayer(){
        let color1 = #colorLiteral(red: 0.9844444394, green: 0.3795444369, blue: 0.3831554055, alpha: 1)
        let color2 = #colorLiteral(red: 0.8943349719, green: 0.1075165048, blue: 0.4612095356, alpha: 1)
        grandiantLayer.colors = [color1.cgColor , color2.cgColor]
        grandiantLayer.locations = [0 , 1]
        view.layer.addSublayer(grandiantLayer)
        grandiantLayer.frame = view.bounds
        

    }
    

    lazy var stackViewVertical : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextFeild,
            emailTextFeild,
            passwordTextFeild,
            registorButton
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoBut,
        stackViewVertical
        ])
    let loginBut : UIButton = {
        let but = UIButton(type: .system)
        but.setTitle("Go login", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        but.setTitleColor(UIColor.white, for: .normal)
        but.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
       return but
    }()
    
    @objc fileprivate func handleLogin() {
        let loginVC = LoginController()
        navigationController?.pushViewController(loginVC, animated: true)
        
    }
    

    
    fileprivate func setupLayout() {

        self.navigationController?.isNavigationBarHidden = true
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectPhotoBut.widthAnchor.constraint(equalToConstant: 275).isActive = true
        stackView.axis = .vertical
        stackView.spacing = 12
        view.addSubview(loginBut)
        loginBut.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        
    }
    

    



}
