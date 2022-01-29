import AppFeature
import ComposableArchitecture
import SwiftUI
import UIKit

@main
struct WiseloApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(store: self.appDelegate.store)
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
      initialState: .init(),
      reducer: appReducer,
      environment: .live
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        ViewStore(self.store).send(.didFinishLaunching)
        return true
    }
}

extension AppEnvironment {
    static var live: Self = .init(
        hostService: .init(),
        mainQueue: .main
    )
}
