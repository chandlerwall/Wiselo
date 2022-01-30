public struct SectionPreference: Equatable, Identifiable {
    public let id: String
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

#if DEBUG

extension SectionPreference {
    static let mockBooth = SectionPreference(id: "1", name: "Booth")
    static let mockHighTop = SectionPreference(id: "2", name: "High Top")
    static let mockIndoor = SectionPreference(id: "3", name: "Indoor")
    static let mockOutdoor = SectionPreference(id: "4", name: "Outdoor")
}

extension Array where Element == SectionPreference {
    static let mock: Self = [.mockBooth, .mockHighTop, .mockIndoor, .mockOutdoor]
}

#endif
