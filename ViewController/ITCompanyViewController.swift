import UIKit
class ITCompanyViewController: ITBasePushTransitionVC
{
    override func viewDidLoad() {
    super.viewDidLoad()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    }
    fileprivate var titles = ["Google",
                              "Microsoft",
                              "Baidu",
                              "Tencent",
                              "Alibaba",
                              "JD",
                              "360",
                              "NetEase",
                              "RenRen",
                              "Xunlei",
                              "sogou",
                              "other"]
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
}
extension ITCompanyViewController {
    fileprivate func setUpUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
}
extension ITCompanyViewController: ITPageTitleViewDelegate {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int) {
        pageContentView.scrollToIndex(index: index)
        self.selectTitleIndex = index
    }
}
extension ITCompanyViewController: ITPageContentViewDelegate {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgerss(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        self.selectTitleIndex = targetIndex
    }
}
