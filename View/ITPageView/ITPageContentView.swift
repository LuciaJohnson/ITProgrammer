import UIKit
fileprivate let ITContentCellID = "ITContentCellID"
protocol ITPageContentViewDelegate: class {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}
class ITPageContentView: UIView {
    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parentVc: UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    weak var delegate: ITPageContentViewDelegate?
    fileprivate var isForbidScrollDelegate: Bool = false
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ITContentCellID)
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ITPageContentView {
    fileprivate func setUpUI() {
        for childVc in childVcs {
            parentVc?.addChild(childVc)
        }
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
extension ITPageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITContentCellID, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
extension ITPageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScrollDelegate { return }
        var sourceIndex = 0
        var targetIndex = 0
        var progress: CGFloat = 0
        let offsetX = scrollView.contentOffset.x
        let ratio = offsetX / scrollView.bounds.width
        progress = ratio - floor(ratio)
        if offsetX > startOffsetX {     
            sourceIndex = Int(offsetX / scrollView.bounds.width)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            if offsetX - startOffsetX == scrollView.bounds.width || progress == 0{
                progress = 1.0
                targetIndex = sourceIndex
            }
        } else  {                       
            targetIndex = Int(offsetX / scrollView.bounds.width)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            progress = 1 - progress
        }
        delegate?.pageContentView(pageContentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
extension ITPageContentView {
    func scrollToIndex(index: Int) {
        isForbidScrollDelegate = true
        let offsetX = CGPoint(x: CGFloat(index) * collectionView.bounds.width, y: 0)
        collectionView.setContentOffset(offsetX, animated: false)
    }
}
