import Testing
import Foundation
@testable import Equated

@Suite("EquatedTests")
struct EquatedTests {
	enum NonEquatableError: LocalizedError {
		case first(String)
		case second(String)

		var errorDescription: String? {
			switch self {
			case let .first(message): message
			case let .second(message): message
			}
		}
	}

	enum EquatableError: LocalizedError, Equatable {
		static func == (lhs: Self, rhs: Self) -> Bool {
			switch (lhs, rhs) {
			case (.first, .first): true
			case (.second, .second): true
			default: false
			}
		}

		case first(String)
		case second(String)

		var errorDescription: String? {
			switch self {
			case let .first(message): message
			case let .second(message): message
			}
		}
	}

	struct NonEquatable {
		let value: Int

		init(_ value: Int = 0) {
			self.value = value
		}
	}

	@Test
	func checkNonEquatableErrorMocks() async throws {
		do {
			let lhs: NonEquatableError = .first("0")
			let rhs: NonEquatableError = .first("0")

			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "0")
		}

		do {
			let lhs: NonEquatableError = .first("0")
			let rhs: NonEquatableError = .first("1")

			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "1")
		}

		do {
			let lhs: NonEquatableError = .second("0")
			let rhs: NonEquatableError = .second("0")

			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "0")
		}

		do {
			let lhs: NonEquatableError = .second("0")
			let rhs: NonEquatableError = .second("1")

			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "1")
		}

		do {
			let lhs: NonEquatableError = .first("0")
			let rhs: NonEquatableError = .second("0")

			#expect(lhs.localizedDescription == rhs.localizedDescription)
		}

		do {
			let lhs: NonEquatableError = .first("0")
			let rhs: NonEquatableError = .second("1")

			#expect(lhs.localizedDescription != rhs.localizedDescription)
		}
	}

	@Test
	func checkEquatableErrorMocks() async throws {
		do {
			let lhs: EquatableError = .first("0")
			let rhs: EquatableError = .first("0")

			#expect(lhs == rhs)
			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "0")
		}

		do {
			let lhs: EquatableError = .first("0")
			let rhs: EquatableError = .first("1")

			#expect(lhs == rhs)
			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "1")
		}

		do {
			let lhs: EquatableError = .second("0")
			let rhs: EquatableError = .second("0")

			#expect(lhs == rhs)
			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "0")
		}

		do {
			let lhs: EquatableError = .second("0")
			let rhs: EquatableError = .second("1")

			#expect(lhs == rhs)
			#expect((lhs as Error).localizedDescription == "0")
			#expect((rhs as Error).localizedDescription == "1")
		}

		do {
			let lhs: EquatableError = .first("0")
			let rhs: EquatableError = .second("0")

			#expect(lhs != rhs)
			#expect(lhs.localizedDescription == rhs.localizedDescription)
		}

		do {
			let lhs: EquatableError = .first("0")
			let rhs: EquatableError = .second("1")

			#expect(lhs != rhs)
			#expect(lhs.localizedDescription != rhs.localizedDescription)
		}
	}

	@Test
	func basicInits() async throws {
		_ = Equated(wrappedValue: NonEquatable(), comparator: .property(\.value))
		_ = Equated(wrappedValue: NonEquatable(), by: .property(\.value))
		_ = Equated(NonEquatable(), by: .property(\.value))
	}

	@Test
	func equatableInits() async throws {
		_ = Equated(wrappedValue: 0)
		_ = Equated(0)
	}

	@Test
	func errorInits() async throws {
		do { // NonEquatableError should be compared by localizedDescription by default
			_ = Equated(wrappedValue: NonEquatableError.first(""))
			_ = Equated(NonEquatableError.first(""))

			do { // equal errors, equal localizedDescriptions
				let lhs: Equated<NonEquatableError> = .init(.first("0"))
				let rhs: Equated<NonEquatableError> = .init(.first("0"))

				#expect((lhs as Error).localizedDescription == (rhs as Error).localizedDescription)
				#expect(lhs == rhs)
			}

			do { // equal errors, not equal localizedDescriptions
				let lhs: Equated<NonEquatableError> = .init(.first("0"))
				let rhs: Equated<NonEquatableError> = .init(.first("1"))

				#expect((lhs as Error).localizedDescription != (rhs as Error).localizedDescription)
				#expect(lhs != rhs)
			}

			do { // not equal errors, equal localizedDescription
				let lhs: Equated<NonEquatableError> = .init(.first("0"))
				let rhs: Equated<NonEquatableError> = .init(.second("0"))

				#expect((lhs as Error).localizedDescription == (rhs as Error).localizedDescription)
				#expect(lhs == rhs)
			}

			do { // not equal errors, not equal localizedDescription
				let lhs: Equated<NonEquatableError> = .init(.first("0"))
				let rhs: Equated<NonEquatableError> = .init(.second("1"))

				#expect((lhs as Error).localizedDescription != (rhs as Error).localizedDescription)
				#expect(lhs != rhs)
			}
		}

		do { // EquatableError should be compared by equatable by default
			_ = Equated(wrappedValue: EquatableError.first(""))
			_ = Equated(EquatableError.first(""))

			do { // equal errors, equal localizedDescriptions
				let lhs: Equated<EquatableError> = .init(.first("0"))
				let rhs: Equated<EquatableError> = .init(.first("0"))

				#expect((lhs as Error).localizedDescription == (rhs as Error).localizedDescription)
				#expect(lhs == rhs)
			}

			do { // equal errors, not equal localizedDescriptions
				let lhs: Equated<EquatableError> = .init(.first("0"))
				let rhs: Equated<EquatableError> = .init(.first("1"))

				#expect((lhs as Error).localizedDescription != (rhs as Error).localizedDescription)
				#expect(lhs == rhs)
			}

			do { // not equal errors, equal localizedDescription
				let lhs: Equated<EquatableError> = .init(.first("0"))
				let rhs: Equated<EquatableError> = .init(.second("0"))

				#expect((lhs as Error).localizedDescription == (rhs as Error).localizedDescription)
				#expect(lhs != rhs)
			}

			do { // not equal errors, not equal localizedDescription
				let lhs: Equated<EquatableError> = .init(.first("0"))
				let rhs: Equated<EquatableError> = .init(.second("1"))

				#expect((lhs as Error).localizedDescription != (rhs as Error).localizedDescription)
				#expect(lhs != rhs)
			}
		}
	}

	@Test
	func optionalInits() async throws {
		_ = Equated<NonEquatable?>(by: .dump)
		_ = Equated<NonEquatable?>()

		_ = Equated<Int?>(by: .defaultEquatable)
		_ = Equated<Int?>()
	}

	@Test
	func propertyWrapperInits() async throws {
		@Equated(comparator: .dump)
		var sut0: Void = ()

		@Equated(by: .defaultEquatable)
		var sut1: Int = 0

		@Equated(by: .detectEquatable())
		var sut2: NonEquatable = .init()

		@Equated(wrappedValue: 0, by: .defaultEquatable)
		var sut3: Int

		@Equated(0, by: .defaultEquatable)
		var sut4: Int

		@Equated
		var sut5: EquatableError = .first("")

		@Equated(by: .property(\.?.errorDescription))
		var sut6: EquatableError?
	}
}
