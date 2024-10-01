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
  /// String literals are still subspecified. Currently, they will just be "something"
  stringLiteral,

  /// The `true` keyword token.
  trueKeyword,

  /// The `type` keyword token.
  typeKeyword,

  /// The unit literal.
  ///
  /// It's represented by the lexeme `()`.
  // TODO(mateusfccp): Maybe this will be unified with the record/struct literal
  unitLiteral,

  /// The verum token (`⊤`).
  verum,

  /// The integer literal.
  /// 
  /// It follows the following grammar:
  /// ```ebnf
  /// <digit_separator> ::= "_"
  /// <integer_literal> ::= <digit>+ ( <digit_separator> <digit>+ )*
  /// ```
  ///
  /// Some examples of valid integer literals:
  /// ```
  /// 0100
  /// 1094812
  /// 100_000
  /// ```
  integerLiteral,

  /// Double literals:
  /// 0.100
  /// 53.000_001
  /// 5_2.000_001
  doubleLiteral;

  @override
  String toString() {
    return switch (this) {
      at => '@',
      colon => ':',
      comma => ',',
      endOfFile => 'EOF',
      equalitySign => '=',
      eroteme => '?',
      falseKeyword => 'false',
      falsum => '⊥',
      identifier => 'identifier',
      importIdentifier => 'import identifier',
      importKeyword => 'import',
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
      trueKeyword => 'true',
      typeKeyword => 'type',
      unitLiteral => '()',
      verum => '⊤',
      integerLiteral => 'integer literal',
      doubleLiteral => 'double literal',
    };
  }
}
