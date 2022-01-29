import Core
import SwiftUI

private struct LoadingViewModifier: ViewModifier {

    let status: LoadingStatus

    func body(content: Content) -> some View {
        switch self.status {
            // FIXME: Implement loading view, error view, placeholder view, and unavailable view.
        case .uninitialized:
            content

        case .loading:
            content

        case .done:
            content

        case .error:
            content

        case .unavailable:
            content

        }
    }
}


extension View {
    public func loading(_ status: LoadingStatus) -> some View {
        self.modifier(
            LoadingViewModifier(status: status)
        )
    }
}

// FIXME: Preview.
