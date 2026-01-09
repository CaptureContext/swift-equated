import Foundation

extension Equated.Comparator where Value: Equatable {
	@inlinable
	public static var defaultEquatable: Self {
		return .uncheckedSendable(==)
	}
}

extension Equated.Comparator {
	public static func detectEquatable(
		checkBoth: Bool = false,
		fallback: Self = .dump
	) -> Self {
		.custom { lhs, rhs in
			guard
				let lhs = lhs as? (any Equatable),
				let rhs = rhs as? (any Equatable)
			else { return fallback.compare(lhs, rhs) }

			if checkBoth {
				return lhs._checkIsEqual(to: rhs) && rhs._checkIsEqual(to: lhs)
			} else {
				return lhs._checkIsEqual(to: rhs)
			}
		}
	}
}

extension Equatable {
	@_spi(Internals)
	public func _checkIsEqual(to other: any Equatable) -> Bool {
		guard let other = other as? Self else { return false }
		return self == other
	}
}
