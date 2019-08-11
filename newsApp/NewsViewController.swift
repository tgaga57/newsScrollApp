//
//  NewsViewController.swift
//  newsApp
//
//  Created by 志賀大河 on 2019/08/11.
//  Copyright © 2019 Taigashiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsViewController: UIViewController,IndicatorInfoProvider {
    
    // urlを受け取る
    var url: String = ""
    
    
    // iteminfowouketoru
    var itemInfo: IndicatorInfo = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
    
    
    
}
