import Foundation

extension Equated {
	public struct Comparator: Sendable {
		public let compare: @Sendable (Value, Value) -> Bool

		@usableFromInline
		internal init(compare: @escaping @Sendable (Value, Value) -> Bool) {
			self.compare = compare
		}
	}
}

extension Equated.Comparator {
	@inlinable
	public var inverted: Self {
		.custom { !compare($0, $1) }
	}

	@inlinable
	public func or(_ comparator: Self) -> Self {
		.custom { lhs, rhs in
			self.compare(lhs, rhs) || comparator.compare(lhs, rhs)
		}
	}

	@inlinable
	public func and(_ comparator: Self) -> Self {
		.custom { lhs, rhs in
			self.compare(lhs, rhs) && comparator.compare(lhs, rhs)
		}
	}

	@inlinable
	public static func const(_ value: Bool) -> Self {
		return .init { _, _ in value }
	}

	@inlinable
	public static func custom(
		_ compare: @escaping @Sendable (Value, Value) -> Bool
	) -> Self {
		return .init(compare: compare)
	}

	@inlinable
	public static var dump: Self {
		.custom { lhs, rhs in
			var (lhsDump, rhsDump) = ("", "")
			Swift.dump(lhs, to: &lhsDump)
			Swift.dump(rhs, to: &rhsDump)
			return lhsDump == rhsDump
		}
	}
}

extension Equated.Comparator: ExpressibleByBooleanLiteral {
	@inlinable
	public init(booleanLiteral value: Bool) {
		self = .const(value)
	}
}
