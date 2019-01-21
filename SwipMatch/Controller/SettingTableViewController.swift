//
//  SettingTableViewController.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/12.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage
class  CustomImagePickerController: UIImagePickerController {
    var imageButton : UIButton?
    
}



extension SettingTableViewController : UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "saving..."
        hud.show(in: view)
        let fileName = UUID()
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.7) else {return}
        ref.putData(uploadData, metadata: nil) { (_, err) in
            if let err = err {
                print(err)
                hud.dismiss()
                return
            }
            ref.downloadURL(completion: { (url, err) in
                if let err = err{
                    print(err)
                    return
                }
                hud.dismiss()
                
                if imageButton == self.image1Button{
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button{
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            })
        }
    }
}

protocol savedUserInfoDelegate {
    func savedUserInfo()
}

class SettingTableViewController: UITableViewController {

    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector:  #selector(handleSelectPhoto))

    var delegate : savedUserInfoDelegate?
    @objc func handleSelectPhoto(button : UIButton ){
        let imagePicker = CustomImagePickerController()
        present(imagePicker, animated: true)
        imagePicker.imageButton = button
        imagePicker.delegate = self
        
        
        
    }
    
    func createButton(selector: Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        setupNavItems()
        
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    var user : User?
    fileprivate func fetchCurrentUser(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print(err)
                hud.dismiss()
                return
            }
            self.user = user
            self.loadUserPhoto(imageUrlString: self.user?.imageUrl1 ?? "", imageBut: self.image1Button)
            self.loadUserPhoto(imageUrlString: self.user?.imageUrl2 ?? "", imageBut: self.image2Button)
            self.loadUserPhoto(imageUrlString: self.user?.imageUrl3 ?? "", imageBut: self.image3Button)
            self.tableView.reloadData()
            hud.dismiss()
        }
    
    }
    fileprivate func loadUserPhoto(imageUrlString : String , imageBut : UIButton){
        if imageUrlString != "" {
            if let imageUrl = URL(string: imageUrlString){
                SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    imageBut.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        } else {
            return
        }

    }
    
    lazy var header : UIView = {
        let header = UIView()
        
        header.addSubview(image1Button)
        let padding : CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stacView = UIStackView(arrangedSubviews: [image2Button,image3Button])
        stacView.axis = .vertical
        stacView.distribution = .fillEqually
        
        header.addSubview(stacView)
        stacView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        stacView.spacing = padding
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0{
            return header
        }
        let sectionLab = HeaderLabel()
        switch section {
        case 1:
            sectionLab.text = "Name"
        case 2:
            sectionLab.text = "Profession"
        case 3:
            sectionLab.text = "Age"
        case 4:
            sectionLab.text = "Bio"
        default:
            sectionLab.text = "Age"
        }
        return sectionLab
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 300

        }
        return 40
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    @objc fileprivate func handleMinSlider (slider : UISlider){
        print(slider.value)
        let index = IndexPath(row: 0, section: 5)
        let ageCell = tableView.cellForRow(at: index) as! AgeRangeTableViewCell
        ageCell.minLabb.text = "Min \(Int(slider.value))"
        self.user?.minSeekingAge = Int(slider.value)

        
    }
    @objc fileprivate func handleMaxSlider (slider : UISlider){
        let index = IndexPath(row: 0, section: 5)
        let ageCell = tableView.cellForRow(at: index) as! AgeRangeTableViewCell
        ageCell.maxLab.text = "Max \(Int(slider.value))"
        self.user?.maxSeekingAge = Int(slider.value)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5{
            let cell = AgeRangeTableViewCell(style: .default, reuseIdentifier: nil)
            cell.minSlider.addTarget(self, action: #selector(handleMinSlider), for: .valueChanged)
            cell.maxSlider.addTarget(self, action: #selector(handleMaxSlider), for: .valueChanged)
            
            let minAge = user?.minSeekingAge ?? 18
            let maxAge = user?.maxSeekingAge ?? 50
            
            cell.minLabb.text = "Min \(minAge)"
            cell.maxLab.text = "Max\(maxAge)"
            cell.minSlider.setValue(Float(user?.minSeekingAge ?? 0), animated: false)
            cell.maxSlider.setValue(Float(user?.maxSeekingAge ?? 0), animated: false)
            return cell
        }
        
        let cell = SettingTableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "enter name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameTextfield), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "enter profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionTextfield), for: .editingChanged)

        case 3:
            cell.textField.placeholder = "enter age"
            if let age = user?.age{
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeTextfield), for: .editingChanged)


        default:
            cell.textField.placeholder = "enter bio"

        }
        return cell
    }
    
    @objc fileprivate func handleNameTextfield (tf : UITextField){
        self.user?.name = tf.text
    }
    @objc fileprivate func handleProfessionTextfield (tf : UITextField){
        print(tf.text ?? "")
        self.user?.profession = tf.text
    }
    @objc fileprivate func handleAgeTextfield (tf : UITextField){
        self.user?.age = Int(tf.text ?? "")
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    fileprivate func setupNavItems() {
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    @objc fileprivate func handleLogout(){
        dismiss(animated: true) {
            try? Auth.auth().signOut()
        }
    }

    
    @objc fileprivate func handleSave(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String : Any] = [
            "uid" : user?.uid ?? "",
            "fullName" : user?.name ?? "",
            "imageUrl1" : user?.imageUrl1 ?? "",
            "imageUrl2" : user?.imageUrl2 ?? "",
            "imageUrl3" : user?.imageUrl3 ?? "",
            "age" : user?.age ?? -1 ,
            "profession" : user?.profession ?? "",
            "minSeekingAge" : user?.minSeekingAge ?? -1 ,
            "maxSeekingAge" : user?.maxSeekingAge ?? -1
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print(err)
                return
            }
            print("successfully saved user data")
            self.dismiss(animated: true, completion: {
                self.delegate?.savedUserInfo()
            })
        }
    }
    

}
