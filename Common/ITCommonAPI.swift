import UIKit
import MessageUI
class ITCommonAPI: NSObject {
    static let sharedInstance = ITCommonAPI()
    private override init() {} 
}
public typealias checkAppUpdateHandler = ((_ isNewVersion: Bool, _ neWversion: String, _ error: Error?) -> ())
extension ITCommonAPI
{
    func checkAppUpdate( newHandler: checkAppUpdateHandler?) {
    }
    func showNewVersion(version: NSString, resultDic: NSDictionary) {
        print(version)
    }
}
extension ITCommonAPI : MFMailComposeViewControllerDelegate
{
    func sendEmail(recipients: Array<String>, messae: String, vc: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(recipients)
            mail.setMessageBody(messae, isHTML: false)
            vc.present(mail, animated: true, completion: nil)
        } else {
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
