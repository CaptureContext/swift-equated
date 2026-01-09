import Foundation

extension Equated.Comparator where Value: Error {
	@inlinable
	public static var localizedDescription: Self {
		.property(\.localizedDescription)
	}
}
