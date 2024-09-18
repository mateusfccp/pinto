import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pinto/syntactic_entity.dart';

/// A program token.
@immutable
final class Token implements SyntacticEntity {
  /// Creates a program token.
  const Token({
    required this.type,
    required this.lexeme,
    required this.offset,
  });

  /// The type of the token.
  final TokenType type;

  /// The string representation of the token.
  final String lexeme;

  /// The offset in which the token was scanned.
  @override
  final int offset;

  @override
  int get length => lexeme.length;

  @override
  int get end => offset + length;

  @override
  String toString() => 'Token(type: $type, lexeme: $lexeme, offset: $offset)';
}

/// The type of a token.
enum TokenType {
  /// The at token (`@`).
  at,

  /// The colon token (`:`)
  colon,

  /// The comma token (`,`).
  comma,

  /// The end-of-file token.
  endOfFile,

  /// The equality sign token (`=`).
  equalitySign,

  /// The eroteme token (`?`).
  ///
  /// The eroteme is also known as the quesiton mark.
  eroteme,

  /// The falsum token (`⊥`).
  falsum,

  /// The `fn` keyword
  fnKeyword,

  /// An identifier.
  ///
  /// pint°'s identifier follows Dart's one. The grammar is the following:
  ///
  /// ```bnf
  /// <identifier>       ::= <identifier_start> <identifier_part>*
  /// <identifier_start> ::= [A-Za-z_$]
  /// <identifier_part>  ::= <identifier_start> | [0-9]
  /// ```
  identifier,

  /// An import identifier.
  ///
  /// The import identifier follows the grammar:
  ///
  ///```bnf
  /// <import_identifier> ::= "@"? <identifier> ( "/" <identifier> )*
  ///```
  importIdentifier,

  /// The `import` keyword token.
  importKeyword,

  /// The left brace token (`{`).
  leftBrace,

  /// The left brace token (`[`).
  leftBracket,

  /// The left parenthesis token (`(`).
  leftParenthesis,

  /// The plus sign token (`+`).
  plusSign,

  /// The right brace token (`}`).
  rightBrace,

  /// The right brace token (`]`).
  rightBracket,

  /// The right parenthesis token (`)`).
  rightParenthesis,

  /// The slash token (`/`).
  slash,

  /// The string literal.
  ///
  /// The string literal follow the grammar:
  ///
  /// ```bnf
  /// <string_literal> ::= '"' + <string_character>* + '"'
  /// <string_character> ::= ~( '"' | '\n' | '\r')
  ///
  stringLiteral,

  /// The `type` keyword token.
  typeKeyword,

  /// The verum token (`⊤`).
  verum;

  @override
  String toString() {
    return switch (this) {
      at => '@',
      colon => ':',
      comma => ',',
      endOfFile => 'EOF',
      equalitySign => '=',
      eroteme => '?',
      falsum => '⊥',
      fnKeyword => 'fn',
      identifier => 'identifier',
      importIdentifier => 'import identifier',
      importKeyword => 'import',
      leftBrace => '{',
      leftBracket => '[',
      leftParenthesis => '(',
      plusSign => '+',
      rightBrace => '}',
      rightBracket => ']',
      rightParenthesis => ')',
      slash => '/',
      stringLiteral => 'string literal',
      typeKeyword => 'type',
      verum => '⊤',
    };
  }
}
