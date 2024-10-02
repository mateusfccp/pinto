## 0.0.4

- Type resolution order fixed
- Initial syntatic tree implementation
- Basic literal implementations:
  - bools
  - Basic strings
  - unit
- Let declarations
- Basic support for function calling

## 0.0.3+1

- Remove included paths information from `pinto` main script

## 0.0.3

- Provide basic LSP implementation through `pinto_server`
- Add resolve error for invalid import

## 0.0.2

- Fix class generation for case where a type parameter is not directly used in
  any of the variants

## 0.0.1

- Basic resolver and parser
- Basic binary that vomits the compiled file into stdout
