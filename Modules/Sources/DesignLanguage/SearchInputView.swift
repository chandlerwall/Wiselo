import SwiftUI

public struct SearchInputView: View {

    let title: String
    let placeholder: String?
    @Binding var text: String

    public init(
        title: String,
        placeholder: String? = nil,
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        TextField(
            self.title,
            text: self.$text,
            prompt: self.placeholder.map(Text.init)
        )
            .textFieldStyle(.roundedBorder)
            // FIXME: Update font color to improve legibility (light and dark mode)
    }
}


#if DEBUG

import PreviewHelpers

struct SearchInputView_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            SearchInputView(
                title: "Preview Input Field",
                placeholder: "Placeholder",
                text: .constant("")
            )
        }
    }
}

#endif
