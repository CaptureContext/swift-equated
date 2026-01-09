import Foundation

extension Equated where Value: Error {
	public var underlyingError: Value { wrappedValue }

	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(wrappedValue: wrappedValue)
	}

	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			wrappedValue: wrappedValue,
			by: .detectEquatable(fallback: .localizedDescription)
		)
	}
}

extension Equated where Value: Error & Equatable {
	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(wrappedValue: wrappedValue)
	}

	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			wrappedValue: wrappedValue,
			by: .defaultEquatable
		)
	}
}
