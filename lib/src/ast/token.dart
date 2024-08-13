import 'package:meta/meta.dart';

/// A Lox program token.
@immutable
final class Token {
  /// Creates a Lox program token.
  const Token({
    required this.type,
    required this.lexeme,
    required this.line,
    required this.column,
  });

  /// The type of the token.
  final TokenType type;

  /// The string representation of the token.
  final String lexeme;

  /// The line in which the token was scanned.
  final int line;

  /// The column in which the token was scanned.
  final int column;

  @override
  String toString() => 'Token(type: $type, lexeme: $lexeme)';
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

  /// The identifier token.
  ///
  /// pint°'s identifier follows Dart's one. The grammar is the following:
  ///
  /// ```bnf
  /// <identifier>       ::= <identifier_start> <identifier_part>*
  /// <identifier_start> ::= [A-Za-z_$]
  /// <identifier_part>  ::= <identifier_start> | [0-9]
  /// ```
  identifier,

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
      identifier => 'identifier',
      importKeyword => 'import',
      leftBrace => '{',
      leftBracket => '[',
      leftParenthesis => '(',
      plusSign => '+',
      rightBrace => '}',
      rightBracket => ']',
      rightParenthesis => ')',
      slash => '/',
      typeKeyword => 'type',
      verum => '⊤',
    };
  }
}
