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

// Color Converter
extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
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
          .font(.title2)
          .monospacedDigit()
          .padding(.trailing, CGFloat(24))
    }
    .activityBackgroundTint(
        lesson!.color != "#676767"
        ? Color(hex: lesson!.color)
        // Ha nem megy hat nem megy
        : Color.clear
    )
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
            ProgressView(
              timerInterval: lesson!.date,
              countsDown: true,
              label: {
                Image(systemName: lesson!.icon)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: CGFloat(32), height: CGFloat(32))
              },
              currentValueLabel: {
                Image(systemName: lesson!.icon)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: CGFloat(32), height: CGFloat(32))
              }
            ).progressViewStyle(.circular)
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
          }.padding(EdgeInsets(top: 0.0, leading: 5.0, bottom: 0.0, trailing: 0.0))
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
      }
    compactTrailing: {
          Text(timerInterval: lesson!.date, countsDown: true)
            .multilineTextAlignment(.center)
            .frame(width: 40)
            .font(.caption2)

      /// Collapsed
      } minimal: {
        VStack(alignment: .center, content: {
          ProgressView(
            timerInterval: lesson!.date,
            countsDown: true,
            label: {
              Image(systemName: lesson!.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(12), height: CGFloat(12))
            },
            currentValueLabel: {
              Image(systemName: lesson!.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(12), height: CGFloat(12))
            }
          ).progressViewStyle(.circular)
        })
      }
      .keylineTint(
        lesson!.color != "#676767"
        ? Color(hex: lesson!.color)
        : Color.clear
      )
    }
  }
}
