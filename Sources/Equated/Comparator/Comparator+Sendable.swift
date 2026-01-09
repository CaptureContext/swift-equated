import Foundation

extension Equated.Comparator {
	@inlinable
	public static func uncheckedSendable(
		_ compare: @escaping (Value, Value) -> Bool
	) -> Self {
		nonisolated(unsafe) let compare = compare
		return .init(compare: { compare($0, $1) })
	}
}
