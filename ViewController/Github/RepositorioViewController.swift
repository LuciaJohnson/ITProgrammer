//
//  RepositorioViewController.swift
//  ConsultaAPIGitHub
//
//  Created by Caio Araujo Mariano on 04/10/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

class RepositorioViewController: UITableViewController {
    
    //MARK: Propriedades
    var searchURL = "https://api.github.com/search/repositories?q=language:Swift&sort=stars&page=1"
    var languageGit = "Swift"
    var userURL = "https://api.github.com/users/"
    var indexOfPageToRequest = 1
    var numberOfRows = 0
    var numberOfRowsInPage = 30
    var repos = [Repository]()
    var loadedPages = 0
    
    // Indicador -- aparece quando a lista carrega no final
    private let indicatorFooter = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView.init()
        
        indicatorFooter.frame.size.height = 100
        indicatorFooter.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorFooter.startAnimating()
        
        getData()
    }
    
    //MARK: Funcoes
    func getData(){
        if(self.loadedPages == 0)
        {
            var hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud!.labelText = "Loading..."
            hud!.dimBackground = true

            self.loadedPages += 1
            
            Repository.downloadRepositories(page: self.loadedPages,Repolanguage: languageGit) { repos in
                self.repos += repos
                self.tableView.tableFooterView = nil
                hud!.removeFromSuperview()
                hud = nil
                self.tableView.reloadData()
            }
        }else
        {
            self.loadedPages += 1
            
            Repository.downloadRepositories(page: self.loadedPages,Repolanguage: languageGit) { repos in
                self.repos += repos
                self.tableView.tableFooterView = nil
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: tableView -- numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
        
    }
    
    //MARK: tableView -- cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        let descriptionLabel = cell?.viewWithTag(3) as! UILabel
        let userNameLabel = cell?.viewWithTag(4) as! UILabel
        let forkCountLabel = cell?.viewWithTag(5) as! UILabel
        let starCountLabel = cell?.viewWithTag(6) as! UILabel
        let userRealNameLabel = cell?.viewWithTag(7) as? UILabel
        
        
        
        
        let repo = self.repos[indexPath.row]
        mainImageView.kf.setImage(with: repo._userAvatarUrl)
//        mainImageView.image = repo.userAvatar
        mainLabel.text = repo.name
        descriptionLabel.text = repo.description
        userNameLabel.text = repo.userLoginName
        userRealNameLabel?.text = repo.userRealName
        forkCountLabel.text = String(repo.quantityOfForks)
        starCountLabel.text = String(repo.quantityOfStargazers)
        
        return cell!
    }
    
    //MARK: tableView -- willDisplay cell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == repos.count {
            tableView.tableFooterView = indicatorFooter
            self.getData()
        }
        
    }
    //MARK: Prepare -- segue PullsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! PullsViewController
        let repo = self.repos[indexPath!]
        vc.repo = repo
    }
    
    @IBAction func backirpgrammeraction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Chooselanguagelist(_ sender: Any) {
        let alert = UIAlertController.init(title: "Languages List", message: nil, preferredStyle: .alert)
        let Swfitaction = UIAlertAction.init(title: "Swift", style: .default) { (Swfitaction) in
            self.languageGit = "Swift"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        
        let Objectcaction = UIAlertAction.init(title: "Objective-c", style: .default) { (Objectcaction) in
            self.languageGit = "Objective-c"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        
        let JavaAction = UIAlertAction.init(title: "Java", style: .default) { (JavaAction) in
            self.languageGit = "Java"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        
        let CandCaction = UIAlertAction.init(title: "C++", style: .default) { (CandCaction) in
            self.languageGit = "C++"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        
        let PHPaction = UIAlertAction.init(title: "PHP", style: .default) { (PHPaction) in
            self.languageGit = "PHP"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        
        let Pythonaction = UIAlertAction.init(title: "Python", style: .default) { (Pythonaction) in
            self.languageGit = "Python"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        let Rubyaction = UIAlertAction.init(title: "Ruby", style: .default) { (Rubyaction) in
            self.languageGit = "Ruby"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        let CSSaction = UIAlertAction.init(title: "CSS", style: .default) { (CSSaction) in
            self.languageGit = "CSS"
            self.loadedPages = 0
            self.repos.removeAll()
            self.getData()
        }
        let CancleAction =  UIAlertAction.init(title: "Cancle", style: .cancel, handler: nil)
        alert.addAction(Swfitaction)
        alert.addAction(Objectcaction)
        alert.addAction(JavaAction)
        alert.addAction(CandCaction)
        alert.addAction(PHPaction)
        alert.addAction(CancleAction)
        alert.addAction(Pythonaction)
        alert.addAction(Rubyaction)
        alert.addAction(CSSaction)
        self.present(alert, animated: true, completion: nil)
    }
}
