import Foundation

extension String {
    public func has(_ text: String) -> Bool {
        return lowercased().range(of: text.lowercased()) != nil
    }

    public var isValid: Bool {
        return !isEmpty
    }

    public func replace(from: String,
                        to: String) -> String {
        return replacingOccurrences(of: from,
                                    with: to)
    }

    public func replace(froms: [String],
                        to: String) -> String {
        var newString = self

        for from in froms {
            newString = newString.replacingOccurrences(of: from,
                                                       with: to)
        }

        return newString
    }

    public func substring(_ length: Int) -> String {
        return count <= length ? self : String(self[..<self.index(self.startIndex, offsetBy: length)])
    }

    public func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
