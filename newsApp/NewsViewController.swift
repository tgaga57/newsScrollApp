//
//  NewsViewController.swift
//  newsApp
//
//  Created by 志賀大河 on 2019/08/11.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit


class NewsViewController: UIViewController,IndicatorInfoProvider,
UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,XMLParserDelegate {
    
    // tabelviewのインスタンスを取得
    var tableView: UITableView = UITableView()
    
    // XMLParserのインスタンスを取得
    var parser = XMLParser()
    
    
    //記事の情報の配列の入れ物
    var articles: [Any] = []
    
    
    // webciew
    @IBOutlet weak var webView: WKWebView!
    
    
    // toolbar(4つ)
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // urlを受け取る
    var url: String = ""
    
    
    // iteminfowouketoru
    var itemInfo: IndicatorInfo = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        
        // parserとの接続
        parser.delegate = self
        
        //navigatiodelegateとの接続
        webView.navigationDelegate = self
        
        // tableview 高さ
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50.0)
        // tableview viewに追加
        self.view.addSubview(tableView)
        
        //最初は隠す(tableviewが表示されるのをジャミしないように)
        webView.isHidden = true
        toolBar.isHidden = true
        
    }
    
    func parserUrl() {
        // url型にチェンジー
        let urlToSend: URL = URL(string: url)!
        
        // parserに解析対象のurlを格納
        parser = XMLParser(contentsOf: urlToSend)!
        
        // 記事情報を初期化
        articles = []
        
        // 解析の実行
        parser.parse()
        // tableViewのリロード
        tableView.reloadData()
        
    }
    
    
    
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 記事の数だけセルを返す
        return articles.count
    }
    
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        // セルの色
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.8633072972, blue: 1, alpha: 1)
        // テキストサイズとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = #colorLiteral(red: 0.3451225162, green: 0.333977282, blue: 0.5054458976, alpha: 1)
        
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        
        return cell
        
        
        
    }
    
    
    // IndicatorInfoProvider のクラスの中に書かないとダメなやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
    
    // セルをタップをした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 後で書く
        
    }
    
    
    // ページの完了で呼び出す
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // tableviewを隠す
        tableView.isHidden = true
        // toolbarを表示
        toolBar.isHidden = false
        // webviewを表示する
        webView.isHidden = false
        
    }
    
    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        // tableviewを出す
        tableView.isHidden = false
            // toolbarを隠す
        toolBar.isHidden = true
        // webviewを隠す
        webView.isHidden = true
        
    }
    
    // 戻る
    @IBAction func backPage(_ sender: Any) {
        
        webView.goBack()
        
    }
    
    // 次へ
    @IBAction func nextPage(_ sender: Any) {
        
        webView.goForward()
    }
    
    
    // リロード
    @IBAction func refresh(_ sender: Any) {
        
        webView.reload()
    }
    
    
    
}
