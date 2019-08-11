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
    
    // XMLファイルに解析をかけた情報
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element: String = ""
    // XMLファイルのタイトル情報
    var titleString: String = ""
    // XMLファイルのリンク情報
    var linkString: String = ""
    
    
    // webview
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
        
        //navigatiodelegateとの接続
        webView.navigationDelegate = self
        
        // tableview 高さ
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50.0)
        // tableview viewに追加
        self.view.addSubview(tableView)
        
        //最初は隠す(tableviewが表示されるのをジャミしないように)
        webView.isHidden = true
        toolBar.isHidden = true
        
        
        parserUrl()
        
    }
    
    func parserUrl() {
        // url型にチェンジー
        let urlToSend: URL = URL(string: url)!
        
        // パースはurlを解析するやつ？
        // parserに解析対象のurlを格納
        parser = XMLParser(contentsOf: urlToSend)!
        
        // 記事情報を初期化
        articles = []
        
        // parserとの接続
        parser.delegate = self
        
        // 解析の実行
        parser.parse()
        // tableViewのリロード
        tableView.reloadData()
        
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // elementNameにタグの名前が入ってくるのでelemetに代入
        
        element = elementName
        
        // タグにitemがあるとき
        if element == "item" {
            
            // 初期化
            elements = [:]
            titleString = ""
            linkString = ""
        }
    }
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "title" {
            // stringにタイトルが入っているのでappend
            titleString.append(string)
        } else if element == "link" {
            linkString.append(string)
        }
    }
    
    // 終了タグを見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // アイテムという要素の中にあるなら、
        if elementName == "item" {
            // titleString,linkStringの中身が空でないなら
            if titleString != "" {
                // elementsに"title"、"Link"というキー値を付与しながらtitleString,linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            
            // articlesの中にelementsを入れる
            articles.append(elements)
        }
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
        cell.backgroundColor = #colorLiteral(red: 0.8021926284, green: 0.9940231442, blue: 0.9937842488, alpha: 1)
        
        // 記事テキストサイズとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title") as? String
        
        // 記事のurlのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        
        return cell
        
        
        
    }
    
    
    // IndicatorInfoProvider のクラスの中に書かないとダメなやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
    
    // セルをタップをした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // webviewを表示する
        let linkURL = ((articles[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlStr = (linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        webView.load(urlRequest as URLRequest)
        
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
