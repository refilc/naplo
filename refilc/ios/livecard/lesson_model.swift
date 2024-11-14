import Foundation

public struct LessonData {
    var color: String
    var icon: String
    var index: String
    var title: String
    var subtitle: String
    var description: String
    var startDate: Date
    var endDate: Date
    var date: ClosedRange<Date>
    var nextSubject: String
    var nextRoom: String
    
    init(from dictionary: [String: Any]) {
        self.color = dictionary["color"] as? String ?? ""
        self.icon = dictionary["icon"] as? String ?? ""
        self.index = dictionary["index"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.subtitle = dictionary["subtitle"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.nextSubject = dictionary["nextSubject"] as? String ?? ""
        self.nextRoom = dictionary["nextRoom"] as? String ?? ""
        
        if let startDateStr = dictionary["startDate"] as? String, let startDateInt = Int(startDateStr) {
            self.startDate = Date(timeIntervalSince1970: TimeInterval(startDateInt) / 1000)
        } else {
            self.startDate = Date()
        }

        if let endDateStr = dictionary["endDate"] as? String, let endDateInt = Int(endDateStr) {
            self.endDate = Date(timeIntervalSince1970: TimeInterval(endDateInt) / 1000)
        } else {
            self.endDate = self.startDate
        }
        
        if self.startDate <= self.endDate {
            self.date = self.startDate...self.endDate
        } else {
            self.date = self.endDate...self.endDate
        }
    }
}
