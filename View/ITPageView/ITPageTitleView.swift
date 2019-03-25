import UIKit
fileprivate let kScroLineH: CGFloat = 2
fileprivate let kTitleMargin: CGFloat = 20
fileprivate let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
fileprivate let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
protocol ITPageTitleViewDelegate: class {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int)
}
class ITPageTitleView: UIView {
    fileprivate var titles: [String]
    fileprivate var currentIndex: Int = 0
    weak var delegate:ITPageTitleViewDelegate?
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = true
        return scrollView
    }()
    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ITPageTitleView {
    fileprivate func setUpUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        setUpTitleLabels()
        setUpBottomLineAndScroLine()
    }
    fileprivate func setUpTitleLabels() {
        var labelX: CGFloat = 0
        let labelH: CGFloat = frame.height - kScroLineH
        let labelY: CGFloat = 0
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            let textNS = title as NSString
            let labelRect:CGRect = textNS.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
            let labelW = labelRect.width + kTitleMargin
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            labelX += labelW
            scrollView.contentSize = CGSize.init(width: labelX, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    fileprivate func setUpBottomLineAndScroLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x + kTitleMargin/2, y: frame.height - kScroLineH, width: firstLabel.frame.width-kTitleMargin, height: kScroLineH)
    }
    fileprivate func scrollToMiddle(targetLabel: UILabel) {
        let targetMinX = targetLabel.frame.minX
        let targetW = targetLabel.frame.width
        let W2 = self.scrollView.frame.size.width/2;
        let contentOffset = self.scrollView.contentOffset.x
        if ((targetMinX+W2+targetW/2) > self.scrollView.contentSize.width) {
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.contentSize.width - W2*2, y: 0), animated: true)
        }else if((targetMinX+contentOffset) > W2){
            self.scrollView.setContentOffset(CGPoint.init(x: targetMinX - W2 + targetW/2, y: 0), animated: true)
        }else if (contentOffset>0 && targetMinX<W2){
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
extension ITPageTitleView {
    @objc fileprivate func titleLabelClick(tapGes: UITapGestureRecognizer) {
        guard let view = tapGes.view else { return }
        let index = view.tag
        if currentIndex == index {
            return
        }
        scrollToIndex(index: index)
        delegate?.pageTitleView(pageTitleView: self, didSelectedIndex: index)
    }
    fileprivate func scrollToIndex(index: Int) {
        let targetLabel = titleLabels[index]
        let oldLabel = titleLabels[currentIndex]
        targetLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        let scrollLineEndX = targetLabel.frame.origin.x + kTitleMargin/2
        let scrollLineW = targetLabel.frame.size.width - kTitleMargin
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineEndX
            self.scrollLine.frame.size.width = scrollLineW
        }
        scrollToMiddle(targetLabel: targetLabel);
        currentIndex = index
    }
}
extension ITPageTitleView {
    func setTitleWithProgerss(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let moveMargin = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let stW = targetLabel.frame.size.width - sourceLabel.frame.size.width
        let progressW = sourceLabel.frame.size.width + stW * progress - kTitleMargin
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + kTitleMargin/2 + moveMargin * progress
        scrollLine.frame.size.width = progressW
        scrollToMiddle(targetLabel: targetLabel);
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        currentIndex = targetIndex
    }
}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
