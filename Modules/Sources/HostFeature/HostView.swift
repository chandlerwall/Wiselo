import SwiftUI

public struct HostView: View {

    public init() { }

    public var body: some View {
        Text("Host")
    }
}

#if DEBUG

import PreviewHelpers

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            HostView()
        }
    }
}

#endif
