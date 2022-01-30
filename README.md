# Wiselo

Wiselo is a toy application that demonstrates Swift, SwiftUI, Combine, and swift-composable-architecture concepts through a simple user interace.

| Wiselo (light) | Wiselo (dark) |
| -------------- | ------------- |
| ![](/Notes/attachments/Pasted image 20220130170724.png) |  ![](/Notes/attachments/Pasted image 20220130170734.png) |

## Getting Started

### Prequisites
- Xcode (tested with version 13.2.1)

### Build Steps
1. Open `Wiselo.xcodeproj` in Xcode
2. Allow Xcode to resolve package versions
3. Select `Wiselo` as the scheme
4. Select any iPhone device as the desnition
5. Build and run

## Project Structure

The project's structure mirrors the project's architecture.

`iOS` contains the entry point of the iOS application: `WiseloApp`. `WiseloApp` is a simple wrapper; all feature-specific functionality is defined in `Modules`.

`Modules` contains a Swift Package with four libraries: `AppFeature`, `HostFeature`, `Core`, and `PreviewHelpers`. Each library encapsulates a specific feature domain of the application. The modules are composed together to produce the overall application. Since the application is a toy, most of the functionality is contained within a single module/library: `HostFeature`. `HostFeature` is composed within `AppFeature`. `AppFeature` could be extended to include additional functionality.

`Notes` contains various notes that were taken during the process.

## Xcode Previews

Xcode previews are available for the various SwiftUI views. Xcode requires the scheme associated with the preview file to be active. For example, the previews within `Moduels/Sources/AppFeature/AppView.swift` are only available when `AppFeature` is the active scheme.
