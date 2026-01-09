import Foundation

extension Equated where Value: Equatable {
	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(wrappedValue, by: .defaultEquatable)
	}

	@inlinable
	public init(wrappedValue: Value) {
		self.init(wrappedValue, by: .defaultEquatable)
	}
}
