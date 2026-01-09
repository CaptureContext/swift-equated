import Testing
import Foundation
@testable import Equated

@Suite("ComparatorTests")
struct ComparatorTests {
	@Test
	func defaultEquatable() async throws {
		let sut: Equated<Int>.Comparator = .defaultEquatable
		#expect(sut.compare(0, 0) == true)
		#expect(sut.compare(0, 1) == false)
		#expect(sut.compare(1, 0) == false)
		#expect(sut.compare(1, 1) == true)
	}

	@Test
	func const() async throws {
		do { // always equal
			let sut: Equated<Int>.Comparator = .const(true)

			do { // actually equal
				let lhs: Int = 0
				let rhs: Int = 0
				#expect(lhs == rhs)
				#expect(sut.compare(lhs, rhs) == true)
			}

			do { // actually not equal
				let lhs: Int = 0
				let rhs: Int = 1
				#expect(lhs != rhs)
				#expect(sut.compare(lhs, rhs) == true)
			}
		}

		do { // always not equal
			let sut: Equated<Int>.Comparator = .const(false)

			do { // actually equal
				let lhs: Int = 0
				let rhs: Int = 0
				#expect(lhs == rhs)
				#expect(sut.compare(lhs, rhs) == false)
			}

			do { // actually not equal
				let lhs: Int = 0
				let rhs: Int = 1
				#expect(lhs != rhs)
				#expect(sut.compare(lhs, rhs) == false)
			}
		}
	}

	@Test
	func bool() async throws {
		do { // always equal
			let sut: Equated<Int>.Comparator = true

			do { // actually equal
				let lhs: Int = 0
				let rhs: Int = 0
				#expect(lhs == rhs)
				#expect(sut.compare(lhs, rhs) == true)
			}

			do { // actually not equal
				let lhs: Int = 0
				let rhs: Int = 1
				#expect(lhs != rhs)
				#expect(sut.compare(lhs, rhs) == true)
			}
		}

		do { // always not equal
			let sut: Equated<Int>.Comparator = false

			do { // actually equal
				let lhs: Int = 0
				let rhs: Int = 0
				#expect(lhs == rhs)
				#expect(sut.compare(lhs, rhs) == false)
			}

			do { // actually not equal
				let lhs: Int = 0
				let rhs: Int = 1
				#expect(lhs != rhs)
				#expect(sut.compare(lhs, rhs) == false)
			}
		}
	}

	@Test
	func custom() async throws {
		// Both args must be 0
		let sut: Equated<Int>.Comparator = .custom { $0 == 0 && $1 == 0 }

		do { // both are 0
			let lhs: Int = 0
			let rhs: Int = 0
			#expect(lhs == rhs)
			#expect(sut.compare(lhs, rhs) == true)
		}

		do { // single 0
			let lhs: Int = 0
			let rhs: Int = 1
			#expect(lhs != rhs)
			#expect(sut.compare(lhs, rhs) == false)
		}

		do { // both are 1
			let lhs: Int = 1
			let rhs: Int = 1
			#expect(lhs == rhs)
			#expect(sut.compare(lhs, rhs) == false)
		}
	}

	@Test
	func dump() async throws {
		struct EquatableByValueOnly: Equatable {
			static func == (lhs: Self, rhs: Self) -> Bool {
				lhs.value == rhs.value
			}

			var value: Int = 0
			var mixin: Int?
		}

		let sut: Equated<EquatableByValueOnly>.Comparator = .dump

		do { // equal with equal mixins
			let lhs: EquatableByValueOnly = .init(value: 0)
			let rhs: EquatableByValueOnly = .init(value: 0)
			#expect(lhs == rhs)
			#expect(sut.compare(lhs, rhs) == true)
		}

		do { // not equal with equal mixins
			let lhs: EquatableByValueOnly = .init(value: 0)
			let rhs: EquatableByValueOnly = .init(value: 1)
			#expect(lhs != rhs)
			#expect(sut.compare(lhs, rhs) == false)
		}

		do { // equal with not equal mixins
			let lhs: EquatableByValueOnly = .init(value: 0, mixin: 0)
			let rhs: EquatableByValueOnly = .init(value: 0, mixin: 1)
			#expect(lhs == rhs)
			#expect(sut.compare(lhs, rhs) == false)
		}

		do { // not equal with not equal mixins
			let lhs: EquatableByValueOnly = .init(value: 0, mixin: 0)
			let rhs: EquatableByValueOnly = .init(value: 1, mixin: 1)
			#expect(lhs != rhs)
			#expect(sut.compare(lhs, rhs) == false)
		}
	}

	@Test
	func localizedDescription() async throws {
		struct MockError: LocalizedError, @unchecked Sendable {
			let message: String

			init(_ message: String) {
				self.message = message
			}

			var errorDescription: String? {
				message
			}
		}

		let sut: Equated<MockError>.Comparator = .localizedDescription

		do { // equal localized descriptions
			let lhs: MockError = .init("")
			let rhs: MockError = .init("")
			#expect(lhs.localizedDescription == rhs.localizedDescription)
			#expect(sut.compare(lhs, rhs) == true)
		}

		do { // not equal localized descriptions
			let lhs: MockError = .init("0")
			let rhs: MockError = .init("1")
			#expect(lhs.localizedDescription != rhs.localizedDescription)
			#expect(sut.compare(lhs, rhs) == false)
		}
	}

	@Test
	func property() async throws {
		struct NonEquatable {
			var value: Int = 0
		}

		let sut: Equated<NonEquatable>.Comparator = .property(\.value)

		do { // equal values
			let lhs: NonEquatable = .init(value: 0)
			let rhs: NonEquatable = .init(value: 0)
			#expect(lhs.value == rhs.value)
			#expect(sut.compare(lhs, rhs) == true)
		}

		do { // not equal values
			let lhs: NonEquatable = .init(value: 0)
			let rhs: NonEquatable = .init(value: 1)
			#expect(lhs.value != rhs.value)
			#expect(sut.compare(lhs, rhs) == false)
		}
	}

	@Test
	func and() async throws {
		do {
			let lhs: Equated<Int>.Comparator = false
			let rhs: Equated<Int>.Comparator = false

			#expect(lhs.compare(0, 0) == false)
			#expect(rhs.compare(0, 0) == false)
			#expect(lhs.and(rhs).compare(0, 0) == false)
		}

		do {
			let lhs: Equated<Int>.Comparator = false
			let rhs: Equated<Int>.Comparator = true

			#expect(lhs.compare(0, 0) == false)
			#expect(rhs.compare(0, 0) == true)
			#expect(lhs.and(rhs).compare(0, 0) == false)
		}

		do {
			let lhs: Equated<Int>.Comparator = true
			let rhs: Equated<Int>.Comparator = false

			#expect(lhs.compare(0, 0) == true)
			#expect(rhs.compare(0, 0) == false)
			#expect(lhs.and(rhs).compare(0, 0) == false)
		}

		do {
			let lhs: Equated<Int>.Comparator = true
			let rhs: Equated<Int>.Comparator = true

			#expect(lhs.compare(0, 0) == true)
			#expect(rhs.compare(0, 0) == true)
			#expect(lhs.and(rhs).compare(0, 0) == true)
		}
	}

	@Test
	func or() async throws {
		do {
			let lhs: Equated<Int>.Comparator = false
			let rhs: Equated<Int>.Comparator = false

			#expect(lhs.compare(0, 0) == false)
			#expect(rhs.compare(0, 0) == false)
			#expect(lhs.or(rhs).compare(0, 0) == false)
		}

		do {
			let lhs: Equated<Int>.Comparator = false
			let rhs: Equated<Int>.Comparator = true

			#expect(lhs.compare(0, 0) == false)
			#expect(rhs.compare(0, 0) == true)
			#expect(lhs.or(rhs).compare(0, 0) == true)
		}

		do {
			let lhs: Equated<Int>.Comparator = true
			let rhs: Equated<Int>.Comparator = false

			#expect(lhs.compare(0, 0) == true)
			#expect(rhs.compare(0, 0) == false)
			#expect(lhs.or(rhs).compare(0, 0) == true)
		}

		do {
			let lhs: Equated<Int>.Comparator = true
			let rhs: Equated<Int>.Comparator = true

			#expect(lhs.compare(0, 0) == true)
			#expect(rhs.compare(0, 0) == true)
			#expect(lhs.or(rhs).compare(0, 0) == true)
		}
	}

	@Test
	func inverted() async throws {
		do {
			let sut: Equated<Int>.Comparator = true

			#expect(sut.compare(0, 0) == true)
			#expect(sut.inverted.compare(0, 0) == false)
		}

		do {
			let sut: Equated<Int>.Comparator = false

			#expect(sut.compare(0, 0) == false)
			#expect(sut.inverted.compare(0, 0) == true)
			#expect(sut.inverted.inverted.compare(0, 0) == false)
		}

		do {
			let sut: Equated<Int>.Comparator = false

			#expect(sut.compare(0, 0) == false)
			#expect(sut.inverted.compare(0, 0) == true)
			#expect(sut.inverted.inverted.compare(0, 0) == false)
		}

		do {
			let sut: Equated<Int>.Comparator = .defaultEquatable

			do {
				let lhs: Int = 0
				let rhs: Int = 0

				#expect(sut.compare(lhs, rhs) == true)
				#expect(sut.inverted.compare(lhs, rhs) == false)
				#expect(sut.inverted.inverted.compare(lhs, rhs) == true)
			}

			do {
				let lhs: Int = 0
				let rhs: Int = 1

				#expect(sut.compare(lhs, rhs) == false)
				#expect(sut.inverted.compare(lhs, rhs) == true)
				#expect(sut.inverted.inverted.compare(lhs, rhs) == false)
			}
		}
	}
}
