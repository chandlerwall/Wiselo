struct SectionPreference: Equatable, Identifiable {
    let id: String
    let name: String
}

extension SectionPreference {
    init(from response: SectionPreferenceResponse) {
        self.init(
            id: String(response.id),
            name: response.preference_name
        )
    }
}
