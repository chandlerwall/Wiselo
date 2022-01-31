# Wiselo

Wiselo is a toy application that demonstrates concepts from Swift, SwiftUI, Combine, and [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture) through a simple user interface. The application targets iOS 15 to explore the latest SwiftUI enhancements (e.g., `ToolbarItemPlacement.keyboard` and `@FocusState`).

| Light | Dark |
| :---: | :---: |
| ![](/Notes/attachments/Pasted%20image%2020220130170724.png) | ![](/Notes/attachments/Pasted%20image%2020220130170734.png) |

## Getting Started

### Perquisites
- Xcode (tested with version 13.2.1)

### Build Steps
1. Open `Wiselo.xcodeproj` in Xcode
2. Allow Xcode to resolve package versions
3. Select `Wiselo` as the scheme
4. Select any iPhone device as the destination (primarily tested on iPhone 13 Pro and 2nd generation iPhone SE)
5. Build and run

## Project Structure

The project's structure mirrors the project's architecture.

`iOS` contains the entry point of the iOS application: `WiseloApp`, a SwiftUI `App`. `WiseloApp` is a simple wrapper; all feature-specific functionality is defined in `Modules`.

`Modules` contains a Swift Package with four libraries: `AppFeature`, `HostFeature`, `Core`, and `PreviewHelpers`. `AppFeature` and `HostFeature` encapsulate a specific feature domain of the application. `Core` and `PreviewHelpers` are utility libraries. The libraries are composed together to produce the overall application.

`Notes` contains various notes that were taken during the process.

## Future Considerations

The main area for extensibility is `AppFeature`. Based on the current functionality, `AppFeature` and `HostFeature` could be consolidated into a single feature. `AppFeature` has been included as a separate feature to demonstrate the extensibility of composable features.

The current implementation of `AppFeature` steps through an animated startup sequence. A more complete implementation could include the following:
- Present a first-launch guide/tutorial
- Require the user to authenticate
- Restore session details from the keychain
- Hydrate feature state with an offline/local database
- Refresh/sync an offline/local database with the latest remote data
- Interrupt the normal startup due to critical updates or important messages
- Activate a demo/guided mode for training purposes

Each of the scenarios above could be accomplished by composing additional features into `AppFeature`'s hierarchy. The linear, action-based sequence in `appReducer` could be refactored into a hierarchical sequence. For example, `AppFeature` could be expanded to include `UnauthenticatedAppFeature` and `AuthenticatedAppFeature`. As the startup process begins, `AppFeature` would be responsible for determining which child feature to activate. Once active, the child feature would be responsible for managing subsequent outcomes.

## Additional Notes

The original feature branches are available to review. Each commit on `main` is a squashed feature branch.

### Xcode Previews

Xcode previews are available for the various SwiftUI views. Xcode requires the scheme associated with the preview file to be active. For example, the previews within `Modules/Sources/AppFeature/AppView.swift` are only available when `AppFeature` is the active scheme. All previews _should_ work (last tested on an M1 MacBook).

## Limitations

### Keyboard Management

Keyboard management is cumbersome within SwiftUI apps. Some basic considerations have been included, but there's room for improvement.

### Mutability and Persistence

The design and types support mutation, but the toy nature of the application prevents editing or persistence (the data never changes).

### Additional Device Support

The project is configured to run on iPhones. The SwiftUI views _should_ adaptively scale, but nothing has been tested on iPad destinations or iPad screen sizes.
