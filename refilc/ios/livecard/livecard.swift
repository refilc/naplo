import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
  var body: some Widget {
      if #available(iOS 16.2, *) {
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

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<LiveActivitiesAppAttributes>

    var body: some View {
        HStack(alignment: .center) {
            // Ikon
            Image(systemName: context.state.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(30), height: CGFloat(30))
                .padding(.leading, CGFloat(24))

            VStack(alignment: .center) {
                // Jelenlegi óra
                VStack {
                  if(context.state.title.contains("Az első órádig")) {
                    Text(context.state.title)
                      .font(.system(size: 15))
                      .bold()
                      .multilineTextAlignment(.center)
                  } else if(context.state.title == "Szünet") {
                    Text(context.state.title)
                      .font(.body)
                      .bold()
                      .padding(.trailing, 90)
                    
                  } else {
                    MultilineTextView(text: "\(context.state.index) \(context.state.title)", limit: 25)
                      .font(.body)
                      .bold()
                      .multilineTextAlignment(.center)
                  }

                //Terem
                if (!context.state.subtitle.isEmpty) {
                      Text(context.state.subtitle)
                          .italic()
                          .bold()
                          .font(.system(size: 13))
                    }
                }

                // Leírás
                if (context.state.description != "") {
                  Text(context.state.description)
                    .font(.subheadline)
                }

                // Következő óra
              if(context.state.nextSubject != "" && context.state.nextRoom != "") {
                HStack {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(8), height: CGFloat(8))
                    Text(context.state.nextSubject)
                        .font(.caption)
                    Text(context.state.nextRoom)
                        .font(.caption2)
                }
                .multilineTextAlignment(.center)
              } else {
                Spacer(minLength: 5)
                Text("Ez az utolsó óra! Kitartást!")
                  .font(.system(size: 15))
              }
                
            }
            .padding(15)

            Spacer()

            // Visszaszámláló
            Text(timerInterval: context.state.date, countsDown: true)
                .multilineTextAlignment(.center)
                .frame(width: 85)
                .font(.title2)
                .monospacedDigit()
                .padding(.trailing)
        }
        .activityBackgroundTint(
            context.state.color != "#676767"
            ? Color(hex: context.state.color)
            : Color.clear
        )
    }
}

@available(iOSApplicationExtension 16.2, *)
struct LiveCardWidget: Widget {
    var body: some WidgetConfiguration {
        /// Live Activity Notification
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
            /// Dynamic Island
        } dynamicIsland: { context in

            /// Expanded
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Spacer()
                        ProgressView(
                            timerInterval: context.state.date,
                            countsDown: true,
                            label: {
                                Image(systemName: context.state.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: CGFloat(32), height: CGFloat(32))
                            },
                            currentValueLabel: {
                                Image(systemName: context.state.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: CGFloat(32), height: CGFloat(32))
                            }
                        ).progressViewStyle(.circular)
                    }
                }
              DynamicIslandExpandedRegion(.center) {
                VStack(alignment: .center) {
                  // Első óra előtti expanded DynamicIsland
                  if(context.state.title.contains("Az első órádig")) {
                    Text("Az első órád:")
                      .font(.body)
                      .bold()
                      .padding(.trailing, -15)
                    MultilineTextView(text: "\(context.state.nextSubject)", limit: 25)
                      .font(.body)
                      .padding(.trailing, -25)
                    
                    Text("Ebben a teremben:")
                      .font(.body)
                      .bold()
                      .padding(.leading, 15)
                    Text(context.state.nextRoom)
                      .font(.body)
                      .padding(.leading, 15)
                  } else if(context.state.title == "Szünet") {
                    // Amikor szünet van, expanded DynamicIsland
                    Text(context.state.title)
                      .lineLimit(1)
                      .font(.body)
                      .bold()
                      .padding(.leading, 15)
                    
                    Spacer(minLength: 5)
                    Text("Következő óra és terem:")
                      .font(.system(size: 13))
                      .padding(.leading, 25)
                    Text(context.state.nextSubject)
                      .font(.caption)
                      .padding(.leading, 15)
                    Text(context.state.nextRoom)
                      .font(.caption2)
                      .padding(.leading, 15)
                    
                  } else {
                    // Amikor óra van, expanded DynamicIsland
                    MultilineTextView(text: "\(context.state.index) \(context.state.title)", limit: 25)
                      .lineLimit(1)
                      .font(.body)
                      .bold()
                      .padding(.trailing, -35)
                    
                    Text(context.state.subtitle)
                      .lineLimit(1)
                      .italic()
                      .bold()
                      .font(.system(size: 13))
                      .padding(.trailing, -50)
                    
                    Spacer(minLength: 5)
                    
                    if(context.state.nextRoom != "" && context.state.nextSubject != "") {
                      Text("Következő óra és terem:")
                        .font(.system(size: 14))
                        .padding(.trailing, -35)
                      Spacer(minLength: 2)
                      Text(context.state.nextSubject)
                        .modifier(DynamicFontSizeModifier(text: context.state.nextSubject))
                        .padding(.trailing, -35)
                      Text(context.state.nextRoom)
                      // ignore: based on nextSubject characters, I check that the font size of the room is the same as the next subject.
                        .modifier(DynamicFontSizeModifier(text: context.state.nextSubject))
                        .padding(.trailing, -35)
                    } else {
                      Text("Ez az utolsó óra! Kitartást!")
                        .font(.system(size: 14))
                        .padding(.trailing, -30)
                    }
                  }
                  
                  
                }.padding(EdgeInsets(top: 0.0, leading: 5.0, bottom: 0.0, trailing: 0.0))
                
              }

                /// Compact
            } compactLeading: {
                  Image(systemName: context.state.icon)
            }
        compactTrailing: {
            Text(timerInterval: context.state.date, countsDown: true)
                .multilineTextAlignment(.center)
                .frame(width: 40)
                .font(.caption2)

            /// Collapsed
        } minimal: {
            VStack(alignment: .center, content: {
                ProgressView(
                    timerInterval: context.state.date,
                    countsDown: true,
                    label: {
                        Image(systemName: context.state.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: CGFloat(12), height: CGFloat(12))
                    },
                    currentValueLabel: {
                        Image(systemName: context.state.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: CGFloat(12), height: CGFloat(12))
                    }
                ).progressViewStyle(.circular)
            })
        }
        .keylineTint(
            context.state.color != "#676767"
            ? Color(hex: context.state.color)
            : Color.clear
           )
        }
    }
}

struct MultilineTextView: View {
    var text: String
    var limit: Int = 20 // default is 20 character

    var body: some View {
        let words = text.split(separator: " ")
        var currentLine = ""
        var lines: [String] = []

        for word in words {
            if (currentLine.count + word.count + 1) > limit {
                lines.append(currentLine)
                currentLine = ""
            }
            if !currentLine.isEmpty {
                currentLine += " "
            }
            currentLine += word
        }
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        return VStack(alignment: .center) {
            ForEach(lines, id: \.self) { line in
                Text(line)
            }
          Spacer(minLength: 1)
        }
    }
}

struct DynamicFontSizeModifier: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize(for: text)))
    }

    private func fontSize(for text: String) -> CGFloat {
        let length = text.count
        if length < 10 {
            return 12
        } else if length < 20 {
            return 12
        } else {
            return 11
        }
    }
}
