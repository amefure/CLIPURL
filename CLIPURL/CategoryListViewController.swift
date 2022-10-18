//
//  CategoryListViewController.swift
//  URList
//
//  Created by t&a on 2022/10/13.
//

import UIKit
import RealmSwift

class CategoryListViewController: UIViewController {
    
    var categoryList: Results<Category>!
        
    let realm = try! Realm()
    
    @IBOutlet weak var categoryTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(UITableView())
        categoryList = realm.objects(Category.self)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryList = realm.objects(Category.self)
        categoryTable.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
