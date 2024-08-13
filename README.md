<img src="https://mateusfccp.me/pinto/images/logo.png" width="300">

[![GitHub License](https://img.shields.io/github/license/mateusfccp/pinto)](./LICENSE)
[![Pub Version](https://img.shields.io/pub/v/pinto)](https://pub.dev/packages/pinto)

The pint° (/pĩntʊ/) programming language.

> [!WARNING]
> The pinto° programming language is still in very early development stage, and is
not recommended for use in production software. Use at your own risk.

The pint° programming language is a language that compiles to Dart.

It has the following objectives:

- Have seamless interoperability with stable Dart;
- Consider Flutter as first-class;
- Generate legible Dart code that can be used as is
- Be terser and more expressive than Dart;
- Provide a powerful macro system with great ergonomy.

Currently, the language is in very early-development, and only supports a single
feature, which is data clases generation.

<!-- more -->

## How to use pint°

### Requirements

You need the latest stable version of Dart installed on your machine.

### Installation

Install the `pinto` executable with `pub`.

```sh
dart pub global activate pinto
```

The `pinto_server` executable will be also available (in the future) for a LSP
implementation.

### Compiling with the `pinto` executable

With the `pinto` executable you can compile a pint° file.

```sh
pinto your_file.pinto
```

The compiled Dart file will me printed in you stdout. This means that, if you
want to redirect it to a file, you may use `>`, like the following example.

```sh
pinto your_file.pinto > your_file.dart
```

## Language overview

### Imports

You may import Dart SDK packages by prefixing `@` in your imports, and regular
packages by not prexing anything. Regular imports depends on the packages
available in your `package_config.json`.

```alloy
import @async // Imports `dart:async`
import flutter_bloc // Imports `package:flutter_bloc/flutter_bloc.dart`
import flutter/widgets // Imports `package:flutter/widgets.dart`
```

Currently, there's no support for relative imports, neither modifiers (`as`,
`show`, `hide`, `if`).

### Types definition

You can define types with the `type` keyword. Each constructor variant is
separated by a `+`. Type parameters are also supported.

```haskell
type Id = Id(int id)

type Option(T) = Some(T value) + None

type Either(L, R) = Left(L value) + Right(R value)
```

If you need to use the top type, in pint° it's identifier by `⊤`. On the other
side, the bottom type is identified by `⊥`.

Pinto introduces some syntax sugar for type identifiers:

* `[T]` for `List(T)`;
* `{T}` for `Set(T)`;
* `{K: V}` for `Map(K, V)`;
* `T?` for `Option(T)`.

The following is a valid pint° program:

```haskell
import @async

type Complex(T) = Complex(
  [⊤] listOfAny,
  [T] listOfT,
  {T} set,
  {T: T} map,
  T? maybeT,
  Future(T) futureOfT,
  int aSimpleInt,
  {{T?} : [Future(T)]} aMonster
)
```
