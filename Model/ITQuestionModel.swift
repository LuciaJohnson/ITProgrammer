import UIKit
class ITQuestionModel: NSObject {
    var ID = ""
    var typeID = ""
    var answer = ""
    var question = ""
    var lauguage = ""
    var type = ""
    var optionA = ""
    var optionB = ""
    var optionC = ""
    var optionD = ""
    var optionAnswer = ""
    var hasOptionQuestion = false
    init(dictionary: Dictionary<String, Any>) {
        ID = dictionary["ID"] as! String
        typeID = dictionary["typeID"] as! String
        answer = dictionary["answer"] as! String
        question = dictionary["question"] as! String
        let typeU = dictionary["type"] as? NSString
        if let typeQ = typeU?.intValue {
            type = dictionary["type"] as! String
            if typeQ == 1 {
                hasOptionQuestion = true
                optionA = dictionary["optionA"] as! String
                optionB = dictionary["optionB"] as! String
                optionC = dictionary["optionC"] as! String
                optionD = dictionary["optionD"] as! String
                optionAnswer = dictionary["optionAnswer"] as! String
            }
        }else{
            type = "0"
        }
    }
}
