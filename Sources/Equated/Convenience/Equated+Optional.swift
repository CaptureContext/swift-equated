import Foundation

extension Equated where Value: ExpressibleByNilLiteral {
	@_disfavoredOverload
	@inlinable
	public init(by comparator: Comparator = .detectEquatable()) {
		self.init(nil, by: comparator)
	}
}

extension Equated where Value: ExpressibleByNilLiteral & Equatable {
	@inlinable
	public init() {
		self.init(nil) // uses .defaultEquatable comparator
	}
}
