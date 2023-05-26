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
    
  init?() {
    let sharedDefault = UserDefaults(suiteName: "group.filcnaplo.livecard")!
      
    self.icon = sharedDefault.string(forKey: "icon")!
    self.index = sharedDefault.string(forKey: "index")!
    self.title = sharedDefault.string(forKey: "title")!
    self.subtitle = sharedDefault.string(forKey: "subtitle")!
    self.description = sharedDefault.string(forKey: "description")!
    self.startDate = Date(timeIntervalSince1970: Double(sharedDefault.string(forKey: "startDate")!)! / 1000)
    self.endDate = Date(timeIntervalSince1970: Double(sharedDefault.string(forKey: "endDate")!)! / 1000)
    date = self.startDate...self.endDate
    self.nextSubject = sharedDefault.string(forKey: "nextSubject")!
    self.nextRoom = sharedDefault.string(forKey: "nextRoom")!
  }
}
