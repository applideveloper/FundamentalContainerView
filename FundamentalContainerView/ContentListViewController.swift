//
//  ContentListViewController.swift
//  FundamentalContainerView
//
//  Created by 酒井文也 on 2016/09/11.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ContentListViewController: UIViewController, UINavigationControllerDelegate {
    
    //ナビゲーションのアイテム
    var leftMenuButton: UIBarButtonItem!
    var rightMenuButton: UIBarButtonItem!
    
    //コンテンツ表示用のテーブルビュー
    @IBOutlet weak var listTableView: UITableView!
    
    /**
     * ヘッダーに入れるコンテナビュー
     * (ポイント)このコンテナに関してはAutoLayoutで制約を張らずにこのViewControllerに置いているだけ
     * → TableViewHeaderをするタイミングでaddSubViewをして、CGRectMakeでサイズを決めうちする。
     *
     */
    @IBOutlet weak var listTableHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationControllerのデリゲート
        self.navigationController?.delegate = self
        
        //ナビゲーションと色設定
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        
        //タイトル用の色および書式の設定
        let attrsMainTitle = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 15)!
        ]
        self.navigationItem.title = "Welcome to This Sample!"
        self.navigationController?.navigationBar.titleTextAttributes = attrsMainTitle
        
        //ナビゲーション用の色および書式の設定
        let attrsBarButton = [
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 16)!
        ]
        
        //左メニューボタンの配置
        leftMenuButton = UIBarButtonItem(title: "🔖", style: .plain, target: self, action: #selector(ContentListViewController.leftMenuButtonTapped(sender:)))
        leftMenuButton.setTitleTextAttributes(attrsBarButton, for: .normal)
        self.navigationItem.leftBarButtonItem = leftMenuButton
        
        //右メニューボタンの配置
        rightMenuButton = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(ContentListViewController.rightMenuButtonTapped(sender:)))
        rightMenuButton.setTitleTextAttributes(attrsBarButton, for: .normal)
        self.navigationItem.rightBarButtonItem = rightMenuButton
        
        
        //UITableViewControllerのデリゲート
        listTableView.delegate = self
        listTableView.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        let nibDefault: UINib = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(nibDefault, forCellReuseIdentifier: "ListTableViewCell")
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //テーブルビューのヘッダーに使用するコンテナの再配置
        listTableHeader.frame = CGRect(
            x: 0, y: 0, width: DeviceSize.screenWidth(), height: 180
        )
        
    }
    
    //左メニューボタンを押した際のアクション
    func leftMenuButtonTapped(sender: UIBarButtonItem) {
        
        /**
         * 親コントローラーのメソッドを呼び出して左コンテンツを開く
         * このコントローラーはUINavigationControllerDelegateを使っているので、
         * 「ViewController(親) → NavigationController(子) → ContentListViewController(孫)」
         * という図式になります。
         *
         */
        let viewController = self.parent?.parent as! ViewController
        viewController.handleMainContentsContainerState(status: MainContentsStatus.LeftMenuOpened)
    }
    
    //右メニューボタンを押した際のアクション
    func rightMenuButtonTapped(sender: UIBarButtonItem) {
        
        /**
         * 親コントローラーのメソッドを呼び出して右コンテンツを開く
         * このコントローラーはUINavigationControllerDelegateを使っているので、
         * 「ViewController(親) → NavigationController(子) → ContentListViewController(孫)」
         * という図式になります。
         *
         */
        let viewController = self.parent?.parent as! ViewController
        viewController.handleMainContentsContainerState(status: MainContentsStatus.RightMenuOpened)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ContentListViewController: UITableViewDelegate {
    
    //テーブルのセル高さ ※任意
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //テーブルヘッダに関する処理 ※任意
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //ヘッダーが必要な物はここにaddSubView → Header用のContainerを突っ込む
        let headerViewBase = UIView()
        headerViewBase.frame = CGRect(
            x: 0, y: 0, width: DeviceSize.screenWidth(), height: 180
        )
        headerViewBase.backgroundColor = UIColor.red
        headerViewBase.addSubview(listTableHeader)
        headerViewBase.isMultipleTouchEnabled = true
        listTableHeader.isMultipleTouchEnabled = true
        return headerViewBase
    }
    
    //セクションヘッダー高さ ※任意
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(180)
    }
    
}

extension ContentListViewController: UITableViewDataSource {
    
    //テーブルの要素数を設定する ※必須
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell
        
        cell!.listTitleLabel.text = "タイトルが入ります"
        cell!.accessoryType = UITableViewCellAccessoryType.none
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    //セルをタップした時に呼び出される
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goContentDetail", sender: nil)
    }
    
}
