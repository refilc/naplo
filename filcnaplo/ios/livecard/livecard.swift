import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      LiveCardWidget()
    }
  }
}

// We need to redefined live activities pipe
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public struct ContentState: Codable, Hashable { }
  
  var id = UUID()
}

struct LockScreenLiveActivityView: View {
  let context: ActivityViewContext<LiveActivitiesAppAttributes>

  let lesson = LessonData()

  var body: some View {
    HStack(alignment: .center) {
      Image(systemName: lesson!.icon)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: CGFloat(30), height: CGFloat(30))
        .padding(.leading, CGFloat(24))

      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          Text(lesson!.index + lesson!.title)
            .font(.title3)
            .bold()

          Text(lesson!.subtitle)
            .font(.subheadline)
            .padding(.trailing, 12)
        }
        
        if (lesson!.description != "") {
          Text(lesson!.description)
            .font(.subheadline)
        }

        HStack {
          Image(systemName: "arrow.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(8), height: CGFloat(8))
          Text(lesson!.nextSubject)
            .font(.caption)
          Text(lesson!.nextRoom)
            .font(.caption2)
        }
      }.padding(15)

      Spacer()
      
      Text(timerInterval: lesson!.date, countsDown: true)
          .multilineTextAlignment(.center)
          .frame(width: 85)
          .font(.title)
          .monospacedDigit()
          .padding(.trailing, CGFloat(24))
    }
  }
}

@available(iOSApplicationExtension 16.1, *)
struct LiveCardWidget: Widget {
  var body: some WidgetConfiguration {
    /// Live Activity Notification
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      LockScreenLiveActivityView(context: context)
    /// Dynamic Island
    } dynamicIsland: { context in
      let lesson = LessonData()
      
      /// Expanded
      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack {
            Spacer()
            Image(systemName: lesson!.icon)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: CGFloat(30), height: CGFloat(30))
              .padding(.leading, CGFloat(6))
              .padding(.bottom, CGFloat(6))
          }
        }
        DynamicIslandExpandedRegion(.center) {
          VStack(alignment: .leading) {
            Text(lesson!.index + lesson!.title)
              .lineLimit(1)
              .font(.title3)
              .bold()
              
            Text(lesson!.description)
              .lineLimit(2)
              .font(.caption)
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          VStack {
            Spacer()
            Text(lesson!.subtitle)
              .lineLimit(1)
              .font(.subheadline)
            Spacer()
          }
        }

      /// Compact
      } compactLeading: {
        Label {
          Text(lesson!.title)
        } icon: {
          Image(systemName: lesson!.icon)
        }
        .font(.caption2)
      } compactTrailing: {
          Text(timerInterval: lesson!.date, countsDown: true)
            .multilineTextAlignment(.center)
            .frame(width: 40)
            .font(.caption2)

      /// Collapsed
      } minimal: {
        VStack(alignment: .center) {
          Image(systemName: lesson!.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(12), height: CGFloat(12))

          Text(timerInterval: lesson!.date, countsDown: true)
            .multilineTextAlignment(.center)
            .monospacedDigit()
            .font(.system(size: CGFloat(10)))
        }
      }
      .keylineTint(.accentColor)
    }
  }
}
