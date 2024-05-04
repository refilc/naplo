import UIKit
import background_fetch
import ActivityKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var methodChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }
    methodChannel = FlutterMethodChannel(name: "hu.refilc/liveactivity",
                                         binaryMessenger: controller as! FlutterBinaryMessenger)
    methodChannel?.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        guard call.method == "createLiveActivity" || call.method == "endLiveActivity" || call.method == "updateLiveActivity" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.handleMethodCall(call, result: result)
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillTerminate(_ application: UIApplication) {
      if #available(iOS 16.2, *) {
            LiveActivityManager.stop()
      }
  }
  
  private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "createLiveActivity" {
      if let args = call.arguments as? [String: Any] {
          lessonDataDictionary = args
          globalLessonData = LessonData(from: lessonDataDictionary)
          print("swift: megkapott flutter adatok:",lessonDataDictionary)
          print("Live Activity bekapcsolva az eszközön: ",checkLiveActivityFeatureAvailable())
          if(checkLiveActivityFeatureAvailable()) {
              createLiveActivity(with: lessonDataDictionary)
              result(checkLiveActivityFeatureAvailable())
          } else {
              result(nil)
          }
        
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid iOS arguments received", details: nil))
      }
    } else if call.method == "updateLiveActivity" {
        if let args = call.arguments as? [String: Any] {
        lessonDataDictionary = args
        globalLessonData = LessonData(from: lessonDataDictionary)
        updateLiveActivity(with: lessonDataDictionary)
        result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid iOS arguments received", details: nil))
        }
    } else if call.method == "endLiveActivity" {
        endLiveActivity()
        result(nil)
    }
  }
    
  private func createLiveActivity(with activityData: [String: Any]) -> String? {
      var lessonData = LessonData(from: activityData)
      print("Live Activity létrehozása...")
      if #available(iOS 16.2, *) {
          LiveActivityManager.create()
      }
      return nil
  }

  private func updateLiveActivity(with activityData: [String: Any]) {
      let lessonData = LessonData(from: activityData)
      print("swift: megkapott flutter adatok:",lessonDataDictionary)
      print("Live Activity frissítés...")
      if #available(iOS 16.2, *) {
          LiveActivityManager.update()
      }
  }

  
  private func endLiveActivity() {
      print("Live Activity befejezése...")
      if #available(iOS 16.2, *) {
          LiveActivityManager.stop()
      }
  }
    
  private func checkIfLiveActivityExists() -> Bool {
      if let activityID = activityID {
          if #available(iOS 16.2, *) {
              return LiveActivityManager.isRunning(activityID)
          }
      }
      return false
  }
    
  private func checkLiveActivityFeatureAvailable() -> Bool {
      if #available(iOS 16.2, *) {
          guard ActivityAuthorizationInfo().areActivitiesEnabled else {
              return false
          }
          return true
      }
      return false
  }
}
