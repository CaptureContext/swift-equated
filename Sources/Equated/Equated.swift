import Foundation

public protocol _EquatedProtocol<Value>: Equatable {
	associatedtype Value
	var wrappedValue: Value { get set }
	var comparator: Equated<Value>.Comparator { get set }
}

@propertyWrapper
public struct Equated<Value>: _EquatedProtocol {
	@inlinable
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.comparator.compare(lhs.wrappedValue, rhs.wrappedValue)
		&& rhs.comparator.compare(rhs.wrappedValue, lhs.wrappedValue)
	}

	public var wrappedValue: Value
	public var comparator: Comparator

	public var projectedValue: Self {
		get { self }
		set { self = newValue }
	}

	@inlinable
	public init(
		wrappedValue: Value,
		comparator: Comparator
	) {
		self.wrappedValue = wrappedValue
		self.comparator = comparator
	}

	@_disfavoredOverload
	@inlinable
	public init(
		_ wrappedValue: Value,
		by comparator: Comparator = .detectEquatable()
	) {
		self.init(
			wrappedValue: wrappedValue,
			comparator: comparator
		)
	}

	@_disfavoredOverload
	@inlinable
	public init(
		wrappedValue: Value,
		by comparator: Comparator = .detectEquatable()
	) {
		self.init(
			wrappedValue: wrappedValue,
			comparator: comparator
		)
	}
}

extension Equated: Sendable where Value: Sendable {}

extension Equated: Hashable where Value: Hashable {
	@inlinable
	public func hash(into hasher: inout Hasher) {
		wrappedValue.hash(into: &hasher)
	}
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Equated: Identifiable where Value: Identifiable {
	@inlinable
	public var id: Value.ID { wrappedValue.id }
}

extension Equated: Comparable where Value: Comparable {
	@inlinable
	public static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.wrappedValue < rhs.wrappedValue
	}
}

extension Equated: Error where Value: Error {
	@inlinable
	public var localizedDescription: String { wrappedValue.localizedDescription }
}

extension Equated: LocalizedError where Value: LocalizedError {
	/// A localized message describing what error occurred.
	@inlinable
	public var errorDescription: String? { wrappedValue.errorDescription }

	/// A localized message describing the reason for the failure.
	@inlinable
	public var failureReason: String? { wrappedValue.failureReason }

	/// A localized message describing how one might recover from the failure.
	@inlinable
	public var recoverySuggestion: String? { wrappedValue.recoverySuggestion }

	/// A localized message providing "help" text if the user requests help.
	@inlinable
	public var helpAnchor: String? { wrappedValue.helpAnchor }
}
