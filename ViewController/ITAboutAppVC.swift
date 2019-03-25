import UIKit
class ITAboutAppVC: UIViewController {
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var copylightLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ITAboutAppVC
{
    func setupUI() {
        self.title = "关于\(kiTalker)"
        guard (self.logoImgView != nil) else {
            return
        }
        self.logoImgView.image = Image.init(named: "iprogrammerLogo")
        self.logoImgView.layer.cornerRadius = 10
        self.logoImgView.layer.masksToBounds = true
        self.appNameLbl.text = kiTalker
        self.versionLbl.text = "v" + KAppVersion
        self.contentLbl.text = "\(kiTalker) 是一款供IT程序员学习的应用.应用内学习内容被分类三类. \n \n 1、开发语言分类,例如swift,python,php,c#...每一种开发语言都提供了大量的知识点学习！\n2、程序员职业进行分类,例如Web developer,ios developer,php engineer...提供了程序员职业中经常遇见的问题解答！\n3、企业面试题,整理了近几年谷歌,微软,百度...企业招聘的面试题.！"
        self.copylightLbl.text = "Copyright © 2019 " + "LuciaJohnson"
    }
}
