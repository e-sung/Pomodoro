import Foundation

extension Locale {
    public static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}

extension TimeZone {
    public static var gmt: TimeZone {
        return TimeZone(identifier: "GMT")!
    }
}

extension DateFormatter {
    /// use GMT timezone and POSIX locale
    public static var standard: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale.posix
        formatter.timeZone = TimeZone.gmt
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }
}
