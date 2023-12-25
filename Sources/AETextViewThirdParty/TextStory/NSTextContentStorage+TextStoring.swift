import Foundation
import AppKit

extension NSTextContentStorage: TextStoring {
	public var length: Int {
		return textStorage?.length ?? 0
	}

	public func applyMutation(_ mutation: TextMutation) {
		textStorage?.applyMutation(mutation)
	}

	public func substring(from range: NSRange) -> String? {
		return textStorage?.substring(from: range)
	}
}
