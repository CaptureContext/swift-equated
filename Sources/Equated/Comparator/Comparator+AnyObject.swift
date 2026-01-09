import Foundation

extension Equated.Comparator where Value: AnyObject {
	public static var objectID: Self {
		.uncheckedSendable(ObjectIdentifier.init)
	}
}
