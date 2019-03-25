import UIKit
class ITLanguageViewController: ITBasePushTransitionVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        launchAnimate()
        self.tabBarController?.tabBar.tintColor = UIColor.orange
    }
    fileprivate var titles = ["Object-C",
                              "Swift",
                              "Java",
                              "C&C++",
                              "PHP",
                              "JavaScript",
                              "Python",
                              "SQL",
                              "C#",
                              "HTML5",
                              "Ruby",
                              "R",
                              "Linux",
                              "BigData",
                              "Algorithm",
                              "NetworkSecurity"]
    fileprivate lazy var pageTitleView: ITPageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH, width: kScreenW, height: kTitleViewH)
        let titleView = ITPageTitleView(frame: titleFrame, titles: self.titles)
        titleView.delegate = self
        return titleView
    }()
    fileprivate lazy var pageContentView: ITPageContentView = {[weak self] in
        let contentH = kScreenH - kStatusBarH - kNavBarH - kHomeIndcator
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH + kTitleViewH, width: kScreenW, height: contentH)
        let counts = 0
        var childVcs = [UIViewController]()
        if let counts = self?.titles.count {
            for i in 0..<counts {
                let vc = ITQuestionListViewController()
                vc.title = self?.titles[i]
                childVcs.append(vc)
            }
        }
    let contentView = ITPageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
    contentView.delegate = self
    return contentView
    }()
    var isFirstLaunch = false
}
extension ITLanguageViewController {
    fileprivate func setUpUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
    func launchAnimate() {
        if !isFirstLaunch {
            isFirstLaunch = true
            let vc = UIStoryboard.init(name: "LaunchScreen", bundle: nil);
            let launchView = vc.instantiateInitialViewController()!.view
            let window =  UIWindow.init(frame: (view?.frame)!)
            window.windowLevel = UIWindow.Level.alert
            window.backgroundColor = UIColor.clear
            window.addSubview(launchView!)
            window.makeKeyAndVisible()
            UIView.animate(withDuration: 1.2, delay: 0.8, options: .beginFromCurrentState, animations: {
                launchView?.transform = CGAffineTransform.init(scaleX: 5, y: 5).rotated(by: CGFloat.pi * 3)
                launchView?.alpha = 0.7
            }, completion: { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    launchView?.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1)
                    launchView?.alpha = 0.0
                }, completion: { (true) in
                    window.removeFromSuperview()
                })
            })
        }
    }
}
extension ITLanguageViewController: ITPageTitleViewDelegate {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int) {
        pageContentView.scrollToIndex(index: index)
        selectTitleIndex = index
    }
}
extension ITLanguageViewController: ITPageContentViewDelegate {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgerss(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        selectTitleIndex = targetIndex
    }
}
