import UIKit
class ITQuestionListViewCell: UITableViewCell {
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var langugeLbl: UILabel!
    @IBOutlet weak var questionLbl: ITCopyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
