import ActivityKit
import WidgetKit
import Foundation

public struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    public struct ContentState: Codable, Hashable {
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
    }
    
    public var id = UUID()
}

@available(iOS 16.2, *)
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    var currentActivity: Activity<LiveActivitiesAppAttributes>?

    class func create() {
           
            Task {
                do {
                    let contentState = LiveActivitiesAppAttributes.ContentState(color: globalLessonData.color, icon: globalLessonData.icon, index: globalLessonData.index, title: globalLessonData.title, subtitle: globalLessonData.subtitle, description: globalLessonData.description, startDate: globalLessonData.startDate, endDate: globalLessonData.endDate, date: globalLessonData.date, nextSubject: globalLessonData.nextSubject, nextRoom: globalLessonData.nextRoom)
                    
                    let activityContent = ActivityContent(state: contentState, staleDate: globalLessonData.endDate, relevanceScore: 0)
                    
                    let activity = try Activity<LiveActivitiesAppAttributes>.request(
                        attributes: LiveActivitiesAppAttributes(),
                        content: activityContent,
                        pushType: nil
                    )
                    
                    activityID = activity.id
                    print("Live Activity létrehozva. Azonosító: \(activity.id)")
                } catch {
                    print("Hiba történt a Live Activity létrehozásakor: \(error)")
                }
            }
    }
        
        class func update() {
                Task {
                    for activity in Activity<LiveActivitiesAppAttributes>.activities {
                        do {
                            let contentState = LiveActivitiesAppAttributes.ContentState(color: globalLessonData.color, icon: globalLessonData.icon, index: globalLessonData.index, title: globalLessonData.title, subtitle: globalLessonData.subtitle, description: globalLessonData.description, startDate: globalLessonData.startDate, endDate: globalLessonData.endDate, date: globalLessonData.date, nextSubject: globalLessonData.nextSubject, nextRoom: globalLessonData.nextRoom)
                            
                            let activityContent = ActivityContent(state: contentState, staleDate: globalLessonData.endDate, relevanceScore: 0)

                            await activity.update(activityContent)
                            activityID = activity.id
                            print("Live Activity frissítve. Azonosító: \(activity.id)")
                        } catch {
                            print("Hiba történt a Live Activity frissítésekor: \(error)")
                        }
                    }
                }
        }
        
        
    class func stop() {
        if (activityID != "") {
            Task {
                for activity in Activity<LiveActivitiesAppAttributes>.activities{
                    let contentState = LiveActivitiesAppAttributes.ContentState(color: globalLessonData.color, icon: globalLessonData.icon, index: globalLessonData.index, title: globalLessonData.title, subtitle: globalLessonData.subtitle, description: globalLessonData.description, startDate: globalLessonData.startDate, endDate: globalLessonData.endDate, date: globalLessonData.date, nextSubject: globalLessonData.nextSubject, nextRoom: globalLessonData.nextRoom)
                    
                    await activity.end(ActivityContent(state: contentState, staleDate: Date.distantFuture),dismissalPolicy: .immediate)
                }
                activityID = nil
                print("Live Activity sikeresen leállítva")
            }
        }
    }

    class func isRunning(_ activityID: String) -> Bool {
            for activity in Activity<LiveActivitiesAppAttributes>.activities {
                if activity.id == activityID {
                    return true
                }
            }
            return false
        }
}
