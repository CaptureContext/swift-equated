# swift-equated

[![CI](https://github.com/CaptureContext/swift-equated/actions/workflows/ci.yml/badge.svg)](https://github.com/CaptureContext/swift-equated/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-equated%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/CaptureContext/swift-equated) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-equated%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/CaptureContext/swift-equated)

Equatable wrapper type and a set of basic comparators.

## Table of Contents

  - [Motivation](#motivation)
  - [The problem](#the-problem)
  - [The solution](#the-solution)
  - [Features](#features)
    - [Predefined comparators](#predefined-comparators)

  - [Installation](#installation)
    - [Basic](#basic)
    - [Recommended](#recommended)

  - [License](#license)

## Motivation

Swift strongly encourages `Equatable`, and for good reason.  
But in practice, equality often disappears at API boundaries:

- values stored as `any`
- errors erased to `Swift.Error`
- closures, reference types, or foreign types
- generic code that cannot add `Equatable` constraints

## The problem

A very common example of this appears when using [TCA](https://github.com/pointfreeco/swift-composable-architecture), though the issue is by no means specific to it.

In TCA it’s idiomatic to make `Action`s equatable for better testing, diffing,
and debugging. But the moment you want to carry an error, you hit a wall:

```swift
enum Action: Equatable {
  case requestFailed(Error) // ❌ 'Error' does not conform to 'Equatable'
}
```

A typical workaround is to introduce a bespoke wrapper type that *forces*
equatability by comparing something like `localizedDescription`:

```swift
struct EquatableError: LocalizedError, Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.localizedDescription == rhs.localizedDescription
  }

  let underlyingError: Error

  var localizedDescription: String {
    underlyingError.localizedDescription
  }
}

enum FeatureAction: Equatable {
  case requestFailed(EquatableError) // ✅ compiles
}
```

This works, but it comes with tradeoffs:

- a new wrapper type must be declared
- an equality strategy must be chosen and documented
- the same pattern is often repeated across features and modules

And the “right” definition of equality is frequently context-dependent.

## The solution

`Equated` lets you keep actions equatable **without** defining custom wrapper types:

```swift
import Equated

enum FeatureAction: Equatable {
  case requestFailed(Equated<Error>) // ✅ compiles
}
```

For errors, it’s enough to simply wrap the value:

```swift
return .send(.requestFailed(Equated(error)))
```

By default, `Equated` chooses an appropriate equality strategy:

- if the underlying error can be compared using `Equatable`, `==` is used
- otherwise it falls back to comparing `localizedDescription`

> [!NOTE]
> _Comparing `localizedDescription` is a heuristic. It is common, but not guaranteed to be unique or stable across localization changes._

Equality can always be customized explicitly when needed:

```swift
return .send(.requestFailed(Equated(error, by: .property(\.code))))
```

## Features

`Equated` is a lightweight `Equatable` container that lets you define equality explicitly, while keeping call sites terse.

### Predefined comparators

Choose how two values should be compared using a `Equated.Comparator`:

#### Automatic

The `detectEquatable` comparator attempts to cast values to `any Equatable` and compare them using `==`:

```swift
.detectEquatable(
  checkBoth: Bool = false,
  fallback: Comparator = .dump
)
```

If equatable comparison is not possible, the provided `fallback` comparator is used.

#### Building blocks

- `.const(Bool)` – always equal / never equal
- `.custom((Value, Value) -> Bool)` – full control
- `.dump` – compares the textual `dump()` output

#### Equatable-driven

- `.defaultEquatable` – equivalent to using `==` directly

#### Property-based

The `property` comparator compares values by a derived equatable projection:

```swift
.property(\.someEquatableProperty)
.property { String(reflecting: $0) }
```

- `.objectID` – compare reference identity (only when `Value: AnyObject`)

#### Error convenience

The `.localizedDescription` comparator is equivalent to `.property(\.localizedDescription)`.

It is typically most useful as a fallback, for example:

```swift
.detectEquatable(fallback: .localizedDescription)
```

#### Concurrency escape hatches

- `.uncheckedSendable((Value) -> any Equatable)`

  _A `property`-style comparator for non-sendable projections_
- `.uncheckedSendable((Value, Value) -> Bool)`

  _A `custom`-style comparator for non-sendable values_

> [!NOTE]
>
> _Most users should prefer `.detectEquatable()` or `.property`_ comparators

## Installation

### Basic

You can add Equated to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-equated"`](https://github.com/capturecontext/swift-equated) into the package repository URL text field
3. Choose products you need to link them to your project.

### Recommended

If you use SwiftPM for your project structure, add Equated to your package file.

```swift
.package(
  url: "https://github.com/capturecontext/swift-equated.git",
  .upToNextMinor(from: "0.0.1")
)
```

or via HTTPS

```swift
.package(
  url: "https://github.com/capturecontext/swift-equated.git",
  .upToNextMinor("0.0.1")
)
```

Do not forget about target dependencies:

```swift
.product(
  name: "Equated",
  package: "swift-equated"
)
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
