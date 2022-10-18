//
//  ListCategoryViewController.swift
//  URList
//
//  Created by t&a on 2022/10/14.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ListCategoryViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate ,UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Realm
    let realm = try! Realm()
    var categoryList:Results<Category>!
    
    // MARK: - Outlet
    @IBOutlet var categoryTable:UITableView!
    
    @IBOutlet var categoryLabel:UILabel!
    
    
    // MARK: - Admob
    var bannerView: GADBannerView!
    lazy var AdMobBannerId: String = {
        return Bundle.main.object(forInfoDictionaryKey: "AdMobBannerId") as! String
    }()
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem:  view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    // MARK: - Admob
    
    // MARK: - セットメソッド
    func setCategory(){
        categoryList = realm.objects(Category.self)
        categoryTable.reloadData()
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.rowHeight = 50
        setCategory()
        
        // MARK: - Admob
        bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(self.view.frame.size.width))
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AdMobBannerId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        // MARK: - Admob
        
    }
    
    // モーダルが閉じられた時に実行させる処置
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        setCategory()
    }
    // MARK: - View
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let data = self.categoryList[indexPath.row]
        cell.create(data.category)
        return cell
    }
    
    // セルを選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "listLocatorPage") as! ListLocatorViewController
        listVC.category = categoryList[indexPath.row].category
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    // スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let destructiveAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            
            let result = self.categoryList[indexPath.row]
            let target = result.category
            
            try! self.realm.write{
                // Category Delete
                self.realm.delete(result)
                
                // Locator Delete
                let allLocator = self.realm.objects(Locator.self)
                let result2 = allLocator.where({ $0.category == target })
                self.realm.delete(result2)
                
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
            
        }
        destructiveAction.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        return configuration
    }
    // MARK: - TableView
    
    
    // MARK: - Action
    @IBAction func showEntryModal(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let entryVC = storyboard.instantiateViewController(withIdentifier: "entryCategoryModal")
        entryVC.modalPresentationStyle = .formSheet
        entryVC.presentationController?.delegate = self
        present(entryVC, animated: true, completion: nil)
    }
    
    
    
}
