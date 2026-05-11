import Foundation

enum ReminderType: String, Codable, Equatable {
    case water
    case movement

    func message(salutation: String, language: AppLanguage = .chinese) -> String {
        AppStrings(language: language).reminderMessage(self, salutation: salutation)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
        case "water":
            self = .water
        case "movement", "stand":
            self = .movement
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown reminder type: \(rawValue)"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
