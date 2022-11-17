import Foundation

class LessonData {
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
    
  init?(JSONData data:[String: String]) {
    self.icon = data["icon"]!
    self.index = data["index"]!
    self.title = data["title"]!
    self.subtitle = data["subtitle"]!
    self.description = data["description"]!
    self.startDate = Date(timeIntervalSince1970: Double(data["startDate"]!)! / 1000)
    self.endDate = Date(timeIntervalSince1970: Double(data["endDate"]!)! / 1000)
    date = self.startDate...self.endDate
    self.nextSubject = data["nextSubject"]!
    self.nextRoom = data["nextRoom"]!
  }
}
