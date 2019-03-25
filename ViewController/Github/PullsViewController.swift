//
//  PullsViewController.swift
//  ConsultaAPIGitHub
//
//  Created by Caio Araujo Mariano on 04/10/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit
import Alamofire

class PullsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    typealias DownloadCompleted = () -> ()
    
    
    //MARK: Outlets
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Propriedades
    var repo: Repository!
    var urlRepository = "https://api.github.com/repos/"
    var pulls = [Pull]()
    
    private let indicatorFooter = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        indicatorFooter.frame.size.height = 100
        indicatorFooter.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorFooter.startAnimating()
        
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView.init()
        self.setViewData()
        
        urlRepository += "\(repo.userLoginName)/\(repo.name)/pulls"
        var hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud!.labelText = "Loading..."
        hud!.dimBackground = true
        self.getData(url: self.urlRepository) {
            hud!.removeFromSuperview()
            hud = nil
            self.tableView.reloadData()
            
        }

    }
    
    //MARK: Actions
    
    
    //MARK: Funcoes
    
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pulls.count
    }
    
    //CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let titleLabel = cell.viewWithTag(1) as? UILabel
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        let prUserLabel = cell.viewWithTag(3) as? UILabel
        let prUserImage = cell.viewWithTag(10) as! UIImageView
        let dateUser = cell.viewWithTag(9) as? UILabel
        
        
        let pull = self.pulls[indexPath.row]
        
        titleLabel?.text = pull.title
        bodyLabel?.text = pull.body
        prUserLabel?.text = pull.name
        dateUser?.text = pull.date
//        prUserImage.image = pull.image
        prUserImage.kf.setImage(with: pull._userDetailAvatarUrl)
        
        
        
        print("Nome: \(pull.name)")
        
        return cell
        
    } // fechamento cellforRowAt
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("clicado")
        let url = URL(string: pulls[indexPath.row].htmlURL)!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
       
    } // Fechemento didSelectRowAt
    
    // Funcao getData
    func getData(url : String, completed: @escaping DownloadCompleted) {
        
        print("url: \(url)")
        
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            
            if let array = result.value as? Array<AnyObject> {
                self.pulls = Pull.getPulls(pullArray: array)
            }
            completed()
        }
    } // Fechamento getData
    
    func setViewData() {

        self.repoImage.kf.setImage(with: self.repo._userAvatarUrl)
        self.repoNameLabel.text = self.repo.name

    }

    //WillDisplay
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == pulls.count {
            //tableView.tableFooterView = indicatorFooter
            
        }
    
    }// Fechemento willDispay
}

