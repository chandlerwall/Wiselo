#if DEBUG

import SwiftUI

public struct DevicePreview<Content>: View where Content: View {

    let content: Content

    public init(
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
    }

    public var body: some View {
        Group {
            self.content
                .environment(\.colorScheme, .light)
                .preferredColorScheme(.light)

            self.content
                .environment(\.colorScheme, .dark)
                .preferredColorScheme(.dark)
        }
    }
}

struct DevicePreview_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            Text("Device Preview")
        }
    }
}

#endif
