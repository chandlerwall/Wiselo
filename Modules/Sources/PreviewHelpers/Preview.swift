#if DEBUG

import SwiftUI

public struct Preview<Content>: View where Content: View {

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
        .previewLayout(.sizeThatFits)
    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            Text("Preview")
        }
    }
}

#endif
