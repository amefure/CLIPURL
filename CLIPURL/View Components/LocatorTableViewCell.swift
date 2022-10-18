//
//  TableViewCell.swift
//  URList
//
//  Created by t&a on 2022/10/13.
//

import UIKit

class LocatorTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet  private weak var titleLable: UILabel!
    @IBOutlet  private weak var urlLabel: UILabel!
    @IBOutlet  private weak var memoLabel: UILabel!
    @IBOutlet  private weak var dateLabel: UILabel!
    
    @IBOutlet private var copyBtn:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        copyBtn.addTarget(self, action: #selector(self.copyAction), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - init
    func create(title:String,url:String,memo:String,date:Date){
        titleLable.text = title
        urlLabel.text = url
        memoLabel.text = memo
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        dateLabel.text = df.string(from: date)
    }
    
    
    // MARK: - Action
    //　シェアボタン
    @IBAction  func shareAction(){
        let shareText = titleLable.text!
        let shareLink = urlLabel.text!
        let items = [shareText, URL(string: shareLink)!] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popPC = activityVC.popoverPresentationController {
                        popPC.sourceView = activityVC.view
                        popPC.barButtonItem = .none
                        popPC.sourceRect = activityVC.accessibilityFrame
                }
            }
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let rootVC = windowScene?.windows.first?.rootViewController
            rootVC?.present(activityVC, animated: true,completion: {})
    }
    
    // コピーボタン
    @objc func  copyAction(sender:UIButton){
        UIPasteboard.general.string = urlLabel.text
        copyBtn.tintColor = .orange
        let mainQ = DispatchQueue.main
        mainQ.asyncAfter ( deadline: DispatchTime.now() + 1) {
          // 非同期で1秒後に実行される
            self.copyBtn.tintColor = UIColor(named: "AccentColor")
        }
    }
    // MARK: - Action
}
