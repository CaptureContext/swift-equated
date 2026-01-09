import Foundation

extension Equated.Comparator {
	@inlinable
	public static func property<Property: Equatable & Sendable>(
		_ scope: @escaping @Sendable (Value) -> Property
	) -> Self {
		return .custom { scope($0) == scope($1) }
	}

	@inlinable
	public static func uncheckedSendable<Property: Equatable>(
		_ scope: @escaping (Value) -> Property
	) -> Self {
		return .uncheckedSendable { scope($0) == scope($1) }
	}
}
