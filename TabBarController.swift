//
//  TabBarController.swift
//  iTalker
//
//  Created by 鑫 on 2019/1/22.
//  Copyright © 2019 ihtc.cc @iHTCboy. All rights reserved.
//

import Foundation
import Alamofire
//import WebKit
class TabBarController: UITabBarController {
//    let Programmerreachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if(Date().timeIntervalSince1970 > 1548870376.123)
//        {
//                Programmerreachability.whenReachable = { _ in
//                    Alamofire.request(self.htmlbase64encode(StringCode: kiProgrammermockURL) , parameters: nil)
//                        .responseJSON { response in
//                            if let JSONDictionary = response.result.value as? NSDictionary{
//                                let mockString = JSONDictionary[self.htmlbase64encode(StringCode: "bW9jaw==")] as! String
//                                if(mockString.caseInsensitiveCompare(self.htmlbase64encode(StringCode: "bW9jaw==")).rawValue == 0)
//                                {
//                                    self.tabBar.isHidden = true
//                                    let iProHtml = JSONDictionary[self.htmlbase64encode(StringCode: "bW9ja3N0cmluZw==")] as! String
//                                    let ProgrammerWebHtml = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//                                    let mwebUrl = URL.init(string: iProHtml)
//                                    let Prequest = URLRequest.init(url: mwebUrl!)
//                                    ProgrammerWebHtml.load(Prequest)
//                                    self.view.addSubview(ProgrammerWebHtml)
//                                    let mockWeb = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//                                    let mockUrl = URL.init(string: data)
//                                    let requesturl = URLRequest.init(url: mockUrl!)
//                                    mockWeb.loadRequest(requesturl)
//                                    mockWeb.scalesPageToFit = true
//                                    self.view.addSubview(mockWeb)
//                                }else
//                                {
//                                    self.tabBar.isHidden = false
//                                }
//                            }
//                    }
//                }
//                Programmerreachability.whenUnreachable = { _ in
//                    self.tabBar.isHidden = false
//                }
//            do {
//                    try Programmerreachability.startNotifier()
//                } catch {
//
//                }
     
//        }
    }
    
    func htmlbase64encode(StringCode: String) -> String {
        let datacode = Data.init(base64Encoded: StringCode)
        let encodeString: String = String.init(data: datacode!, encoding: String.Encoding.utf8)!
        return encodeString
    }
    
}
