//
//  EntryLocatorViewController.swift
//  URList
//
//  Created by t&a on 2022/10/13.
//

import UIKit
import RealmSwift

class EntryLocatorViewController: UIViewController ,UITextFieldDelegate {
    
    // MARK: - Outlet
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var memoTextField: UITextField!

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    
    // MARK: - receive parent
    var category = ""
    
    // MARK: - instance
    let realm = try! Realm()
    
    // MARK: - method
    func resetData(){
        titleTextField.text = ""
        urlTextField.text = ""
        memoTextField.text = ""
    }
    
    // MARK: - validation
    func validationInput() -> Bool{
        if titleCheck() && urlCheck(){
            return true
        }
        return false
    }
    
    func titleCheck() -> Bool{
        if titleTextField.text == "" {
            return false
        }
        return true
    }
    
    func urlCheck() -> Bool {
        if urlTextField.text == "" {
            return false
        }
        let urlStr = urlTextField.text!
        if let nsurl = NSURL(string: urlStr){
            return UIApplication.shared.canOpenURL(nsurl as URL)
        }
        return false
    }
    // MARK: - validation
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        urlTextField.delegate = self
        memoTextField.delegate = self
        
    }
    
    
    // MARK: - buttonTapped
    @IBAction func entryData() {
        
        if validationInput(){
            
            let obj = Locator()
            obj.title = titleTextField.text!
            obj.url = urlTextField.text!
            obj.memo = memoTextField.text!
            obj.category = category
            
            try! realm.write {
                realm.add(obj)
            }
            
            resetData()

            // 親のpresentationControllerDidDismissを実行
            if let presentationController = presentationController{
                presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
            }
            self.dismiss(animated: true,completion: nil)
            
        }else{
            if titleCheck() == false {
                titleLabel.textColor = .orange
            }
            
            if urlCheck() == false {
                urlLabel.textColor = .orange
            }
        }
    }
    
    // MARK: - TextField Closed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
}
