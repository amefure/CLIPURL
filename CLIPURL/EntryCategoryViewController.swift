//
//  EntryCategoryViewController.swift
//  CLIPURL
//
//  Created by t&a on 2022/10/14.
//

import UIKit
import RealmSwift

class EntryCategoryViewController: UIViewController,UITextFieldDelegate {

    // MARK: - Outlet
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var categoryLabel: UILabel!
    
    // MARK: - Realm
    let realm = try! Realm()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.delegate = self
    }
    
    // MARK: - Validation
    func validationInput() -> Bool{
        if categoryTextField.text == "" {
            return false
        }
        return true
    }
    
    // MARK: - Action
    @IBAction func createCategory(){
        if validationInput(){
            
            
            let obj = Category()
            obj.category = categoryTextField.text!
            
            try! realm.write {
                realm.add(obj)
            }
            
            // 親のpresentationControllerDidDismissを実行
            if let presentationController = presentationController{
                presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
            }
            self.dismiss(animated: true,completion: nil)
            
        }else{
            categoryLabel.textColor = .orange
        }
    }
    
    // MARK: - TextField Closed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}
