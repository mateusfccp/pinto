import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pinto/syntactic_entity.dart';

/// A program token.
@immutable
final class Token implements SyntacticEntity {
  /// Creates a program token.
  const Token({required this.type, required this.lexeme, required this.offset});

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

  /// /// The double literal.
  ///
  /// It follows the following grammar:
  /// ```ebnf
  /// <digit_separator> ::= "_"
  /// <integer_literal> ::= <digit> (<digit_separator>* <digit>+)*
  /// <double_literal>  ::= <integer_literal> "." <integer_literal>
  /// ```
  ///
  /// Some examples of valid double literals:
  /// ```
  /// 0.100
  /// 53.000_001
  /// 5_2.000_001
  /// 5__2.000___001
  /// ```
  doubleLiteral,

  /// The end-of-file token.
  endOfFile,

  /// The equality sign token (`=`).
  equalitySign,

  /// The eroteme token (`?`).
  ///
  /// The eroteme is also known as the quesiton mark.
  eroteme,

  /// The false keyword.
  falseKeyword,

  /// The falsum token (`⊥`).
  falsum,

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

  /// The integer literal.
  ///
  /// It follows the following grammar:
  /// ```ebnf
  /// <digit_separator> ::= "_"
  /// <integer_literal> ::= <digit> (<digit_separator>* <digit>+)*
  /// ```
  ///
  /// Some examples of valid integer literals:
  /// ```
  /// 0100
  /// 1094812
  /// 100_000
  /// 1__000
  /// ```
  integerLiteral,

  /// The left brace token (`{`).
  leftBrace,

  /// The left brace token (`[`).
  leftBracket,

  /// The left parenthesis token (`(`).
  leftParenthesis,

  /// The let keyword.
  letKeyword,

  /// The plus sign token (`+`).
  plusSign,

  /// A reserved token.
  reserved,

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
  /// String literals are still underspecified. Currently, they will just be "something".
  stringLiteral,

  /// The symbol literal.
  ///
  /// It follows the following grammar:
  /// ```ebnf
  /// <symbol_literal> ::= ":" <identifier>
  /// ```
  symbolLiteral,

  /// The `true` keyword token.
  trueKeyword,

  /// The `type` keyword token.
  typeKeyword,

  /// The verum token (`⊤`).
  verum;

  String get code {
    return switch (this) {
      at => 'at',
      colon => 'colon',
      comma => 'comma',
      doubleLiteral => 'double_literal',
      endOfFile => 'eof',
      equalitySign => 'equality_sign',
      eroteme => 'question_mark',
      falseKeyword => 'false',
      falsum => 'bottom_type',
      identifier => 'identifier',
      importIdentifier => 'import_identifier',
      importKeyword => 'import',
      integerLiteral => 'integer_literal',
      leftBrace => 'left_brace',
      leftBracket => 'left_bracket',
      leftParenthesis => 'left_parenthesis',
      letKeyword => 'let',
      plusSign => 'plus_sign',
      reserved => 'reserved',
      rightBrace => 'right_brace',
      rightBracket => 'right_bracket',
      rightParenthesis => 'right_parenthesis',
      slash => 'slash',
      stringLiteral => 'string_literal',
      symbolLiteral => 'symbol_literal',
      trueKeyword => 'true',
      typeKeyword => 'type',
      verum => 'top_type',
    };
  }

  @override
  String toString() {
    return switch (this) {
      at => '@',
      colon => ':',
      comma => ',',
      doubleLiteral => 'double literal',
      endOfFile => 'EOF',
      equalitySign => '=',
      eroteme => '?',
      falseKeyword => 'false',
      falsum => '⊥',
      identifier => 'identifier',
      importIdentifier => 'import identifier',
      importKeyword => 'import',
      integerLiteral => 'integer literal',
      leftBrace => '{',
      leftBracket => '[',
      leftParenthesis => '(',
      letKeyword => 'let',
      plusSign => '+',
      reserved => 'reserved token',
      rightBrace => '}',
      rightBracket => ']',
      rightParenthesis => ')',
      slash => '/',
      stringLiteral => 'string literal',
      symbolLiteral => 'symbol literal',
      trueKeyword => 'true',
      typeKeyword => 'type',
      verum => '⊤',
    };
  }
}
