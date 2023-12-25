import AppKit

extension NSTextLocation {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedAscending
	}

	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedSame
	}

	public static func <= (lhs: Self, rhs: Self) -> Bool {
		return lhs < rhs || lhs == rhs
	}

	public static func > (lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedDescending
	}

	public static func >= (lhs: Self, rhs: Self) -> Bool {
		return lhs > rhs || lhs > rhs
	}
}
