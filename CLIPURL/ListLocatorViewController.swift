//
//  ListViewController.swift
//  URList
//
//  Created by t&a on 2022/10/13.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ListLocatorViewController:UIViewController ,UITableViewDataSource, UITableViewDelegate,UIAdaptivePresentationControllerDelegate {
    
    // MARK: - receive property
    var category:String = ""
    
    // MARK: - Realm
    let realm = try! Realm()
    var locatorList: Results<Locator>!
    
    
    // MARK: - Outlet
    @IBOutlet weak var locatorTable: UITableView!
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
    func setLocator(){
        let allLocatorList = realm.objects(Locator.self)
        locatorList = allLocatorList.where({ $0.category == category })
        locatorTable.reloadData()
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        locatorTable.rowHeight = 110 // セルの高さを設定
        setLocator()
        categoryLabel.text = category
        
        // MARK: - Admob
        //GADBannerViewの作成
        // 旧値：kGADAdSizeSmartBannerPortrait
        // 警告:'kGADAdSizeSmartBannerPortrait' is deprecated: Use GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth.
        // 新値：GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(self.view.frame.size.width)
        bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(self.view.frame.size.width))
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AdMobBannerId
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
        // MARK: - Admob
    }
    
    // モーダルが閉じられた時に実行させる処置
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        setLocator()
    }
    // MARK: - View
    
    // MARK: -TableView
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locatorList.count;
    }
    
    // セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocatorTableViewCell", for: indexPath) as! LocatorTableViewCell
        let data = self.locatorList[indexPath.row]
        cell.create(title: data.title, url: data.url, memo: data.memo, date:data.date)
        return cell
    }
    
    // セルを選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let url = URL(string:locatorList[indexPath.row].url)!
        let application = UIApplication.shared // シングルトンのインスタンスを取得
        application.open(url) // URL Linkへ遷移
    }
    
    // スワイプアクション
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let destructiveAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            let result = self.locatorList[indexPath.row]
            try! self.realm.write{
                self.realm.delete(result)
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
    @IBAction func  showEntryModal(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let entryVC = storyboard.instantiateViewController(withIdentifier: "entryLocatorModal") as! EntryLocatorViewController
        entryVC.modalPresentationStyle = .formSheet
        entryVC.category = category
        entryVC.presentationController?.delegate = self
        present(entryVC, animated: true, completion: nil)
    }
    
    
   
    
}

