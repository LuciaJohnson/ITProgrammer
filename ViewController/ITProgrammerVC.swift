import UIKit
import StoreKit
import SafariServices
import CoreLocation
class ITProgrammerVC: UIViewController {
    var locationManager:CLLocationManager = CLLocationManager.init()
    var locationCurrent:CLLocation = CLLocation.init()
    var Weather2D:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() != .authorizedWhenInUse || CLLocationManager.authorizationStatus() != .authorizedAlways)
        {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        setupUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    var isNewVersion = false
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-49), style: .grouped)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: -49, right: 0)
        tableView.sectionFooterHeight = 0.1;
        tableView.estimatedRowHeight = 55
        return tableView
    }()
    fileprivate var titles = ["0":"Image题库:实拍面试题目,Github:学习Github源码,SmileWeather:学习源码实例",
        "1":"bug反馈:期待您的使用意见,Email联系:期待您的来信,github地址:源码开放欢迎学习,Share应用:分享给您的好友！,About应用:\(kiTalker)"] as [String : String]
}
extension ITProgrammerVC : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.count > 0)
        {
            self.locationCurrent = locations[0]
            self.Weather2D = locations[0].coordinate
        }
    }
}
extension ITProgrammerVC
{
    func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    func gotoAppstore(isAssessment: Bool) {
    }
}
extension ITProgrammerVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let string = self.titles["\(section)"]
        let titleArray = string?.components(separatedBy: ",")
        return (titleArray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ITProgrammerVCViewCell")
        if (cell  == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "ITProgrammerVCViewCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.selectedBackgroundView = UIView.init(frame: cell!.frame)
            cell!.selectedBackgroundView?.backgroundColor = kColorAppOrange.withAlphaComponent(0.7)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 20:16.5)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 16:12.5)
            cell?.detailTextLabel?.sizeToFit()
        }
        let string = self.titles["\(indexPath.section)"]
        let titleArray = string?.components(separatedBy: ",")
        let titles = titleArray?[indexPath.row]
        let titleA = titles?.components(separatedBy: ":")
        cell!.textLabel?.text = titleA?[0]
        cell?.detailTextLabel?.text = titleA?[1]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section;
        let row = indexPath.row;
        switch section {
        case 0:
                        if row == 0 {
                            let vc = NTWaterfallViewController.init(collectionViewLayout:CHTCollectionViewWaterfallLayout())
                            let nav = NTNavigationController.init(rootViewController: vc)
                            vc.title = "实拍面试题目"
                            self.present(nav, animated: true, completion: nil);
                        }
                        if row == 1 {
                         let Mainboard = UIStoryboard.init(name: "Main", bundle: nibBundle)
//                         let RepoController = Mainboard.instantiateViewController(withIdentifier: "RepositorioViewController")
                            let NaviRoot = Mainboard.instantiateViewController(withIdentifier: "NaviRoot")
//                            NaviRoot.rootView
                            
                        self.present(NaviRoot, animated: true, completion: nil)
                        }
                        if row == 2 {
                            if(self.locationCurrent.coordinate.latitude == 0.0 || self.locationCurrent.coordinate.longitude == 0.0)
                            {
                                let alert = UIAlertController.init(title: "Tips", message: "Current location failed, please reposition", preferredStyle: .alert)
                               let actionOk = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                                alert.addAction(actionOk)
                                self.present(alert, animated: true, completion: nil)
                                return ;
                            }else
                            {
                                let WeatherGit = GithubWeatherViewController.init()
                                WeatherGit.loaction = self.locationCurrent
                                WeatherGit.lat = self.Weather2D.latitude
                                WeatherGit.lng = self.Weather2D.longitude
                                self.present(WeatherGit, animated: true, completion: nil)
                            }
                        }
                    break
        case 1:
            if row == 0 {
                if #available(iOS 9.0, *) {
                    let vc = SFSafariViewController(url: URL(string: kissueAction
                        )!, entersReaderIfAvailable: true)
                    if #available(iOS 10.0, *) {
                        vc.preferredBarTintColor = kColorAppBlue
                        vc.preferredControlTintColor = UIColor.white
                    }
                    if #available(iOS 11.0, *) {
                        vc.dismissButtonStyle = .close
                    }
                    present(vc, animated: true)
                } else {
                    if UIApplication.shared.canOpenURL(URL.init(string: kissueAction )!) {
                        UIApplication.shared.openURL(URL.init(string: kissueAction)!)
                    }
                }
            }
            if row == 1 {
                let message = "感谢您的来信，请阐述你的内容" + "\n\n\n\n" + kMarginLine + "\n 当前\(kiTalker)版本：" + KAppVersion + "， 系统版本：" + String(Version.SYS_VERSION_FLOAT) + "， 设备信息：" + UIDevice.init().modelName
                ITCommonAPI.sharedInstance.sendEmail(recipients: [kEmail], messae: message, vc: self)
            }
            if row == 2 {
                if #available(iOS 9.0, *) {
                    let vc = SFSafariViewController(url: URL(string: kGithubURL
                        )!, entersReaderIfAvailable: true)
                    if #available(iOS 10.0, *) {
                        vc.preferredBarTintColor = kColorAppBlue
                        vc.preferredControlTintColor = UIColor.white
                    }
                    if #available(iOS 11.0, *) {
                        vc.dismissButtonStyle = .close
                    }
                    present(vc, animated: true)
                } else {
                    if UIApplication.shared.canOpenURL(URL.init(string: kGithubURL )!) {
                        UIApplication.shared.openURL(URL.init(string: kGithubURL)!)
                    }
                }
            }
            if row == 3 {
                let image = UIImage(named: "iprogrammerLogo")
                                let url = NSURL(string: kAppDownloadURl)
                                let string = "Hi, ITProgrammer! 这是IT程序员学习的应用！" + "github链接：" + kAppDownloadURl
                                let activityController = UIActivityViewController(activityItems: [image! ,url!,string], applicationActivities: nil)
                                self.present(activityController, animated: true, completion: nil)
            }
            if row == 4 {
                let vc = ITAboutAppVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        default: break
        }
    }
}
