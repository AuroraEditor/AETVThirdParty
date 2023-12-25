import Foundation

/// A concrete `TextStoring` implementation that uses functions to apply the `TextStoring` protocol.
///
/// This class exists to help connect a `MainActor`-isolated system to a `TextStoring`-compatible type.
public final class TextStorageAdapter {
    public typealias LengthProvider = () -> Int
	public typealias SubstringProvider = (NSRange) -> String?
	public typealias MutationApplier = (TextMutation) -> Void

    public let lengthProvider: LengthProvider
    public let substringProvider: SubstringProvider
	public let mutationApplier: MutationApplier

    public init(
		lengthProvider: @escaping LengthProvider,
		substringProvider: @escaping SubstringProvider,
		mutationApplier: @escaping MutationApplier
	) {
        self.lengthProvider = lengthProvider
        self.substringProvider = substringProvider
		self.mutationApplier = mutationApplier
    }
}

extension TextStorageAdapter: TextStoring {
	public var length: Int {
		lengthProvider()
	}

    public func substring(from range: NSRange) -> String? {
		substringProvider(range)
    }

    public func applyMutation(_ mutation: TextMutation) {
		mutationApplier(mutation)
    }
}

extension TextStoring {
	func registerMutation(_ mutation: TextMutation, with undoManager: UndoManager?) {
		guard let manager = undoManager else { return }
		let inverse = inverseMutation(for: mutation)

		manager.registerUndo(withTarget: self, handler: { $0.applyMutation(inverse) })
	}
}

import AppKit

extension NSTextView {
    func applyMutation(_ mutation: TextMutation) {
        guard let storage = textStorage else { return }

        if let manager = undoManager {
            let inverse = storage.inverseMutation(for: mutation)

            manager.registerUndo(withTarget: self, handler: { $0.applyMutation(inverse) })
        }

        replaceCharacters(in: mutation.range, with: mutation.string)

        didChangeText()
    }
}

extension TextStorageAdapter {
    @MainActor
    public convenience init(textView: NSTextView) {
        self.init {
            textView.textStorage?.length ?? 0
        } substringProvider: { range in
            textView.textStorage?.substring(from: range)
        } mutationApplier: { mutation in
            textView.applyMutation(mutation)
        }
    }
}
