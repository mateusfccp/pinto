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
    this.literal,
  });

  /// The type of the token.
  final TokenType type;

  /// The string representation of the token.
  final String lexeme;

  /// The line in which the token was scanned.
  final int line;

  /// The column in which the token was scanned.
  final int column;

  /// The literal represented by the token.
  ///
  /// If the token does not represent any literal, this will be `null`.
  final Object? literal;

  @override
  String toString() => '$type $lexeme $literal';

  static bool same(Token a, Token b) => a.type == b.type && a.lexeme == b.lexeme;
}

/// The type of a token.
enum TokenType {
  /// The left parenthesis token (`(`).
  leftParenthesis,

  /// The right parenthesis token (`)`).
  rightParenthesis,

  /// The left brace token (`[`).
  leftBracket,

  /// The right brace token (`]`).
  rightBracket,

  /// The left brace token (`{`).
  leftBrace,

  /// The right brace token (`}`).
  rightBrace,

  /// The comma token (`,`).
  comma,

  /// The dot token (`.`).
  dot,

  /// The minus sign token (`-`).
  minus,

  /// The plus sign token (`+`).
  plus,

  /// The semicolon token (`;`).
  semicolon,

  /// The slash token (`/`).
  slash,

  /// The asterisk token (`*`).
  asterisk,

  // The bang token (`!`).
  bang,

  /// The bang-equal token (`!=`).
  bangEqual,

  /// The equal token (`=`).
  equal,

  /// The equal-equal token (`==`).
  equalEqual,

  /// The greater-than token (`>`).
  greater,

  /// The greater-than-or-equal-to token (`>=`).
  greaterEqual,

  /// The less-than token (`<`).
  less,

  /// The less-than-or-equal-to token (`<=`).
  lessEqual,

  /// The left arrow token (`←`)
  leftArrow,

  /// The right arrow token (`→`)
  rightArrow,

  /// The fat right arrow token (`=>`)
  fatRightArrow,

  /// The pipe token (`|`)
  pipeToken,

  /// The colon token (`:`)
  colon,

  /// The double colon token (`::`)
  doubleColon,

  /// The product token (`×`)
  product,

  /// The identifier token.
  identifier,

  /// The string literal token (`"string"`).
  string,

  /// The symbol literal token (`'symbol`)
  symbol,

  /// The integer literal token (`0<base>0000`)
  integer,

  /// The double literal token(`0.0`)
  double,

  /// The `and` keyword token (`and`).
  andKeyword,

  /// The `class` keyword token (`class`).
  classKeyword,

  /// The `else` keyword token.
  elseKeyword,

  /// The `false` keyword token.
  falseKeyword,

  /// The `fn` keyword token.
  fnKeyword,

  /// The `for` keyword token.
  forKeyword,

  /// The `if` keyword token.
  ifKeyword,

  /// The `unless` keyword token.
  unlessKeyword,

  /// The `or` keyword token.
  orKeyword,

  /// The `super` keyword token.
  superKeyword,

  /// The `this` keyword token.
  thisKeyword,

  /// The `true` keyword token.
  trueKeyword,

  /// The `let` keyword token.
  letKeyword,

  /// The `type` keyword token.
  typeKeyword,

  /// The `typealias` keyword token.
  typealiasKeyword,

  /// The `in` keyword token.
  inKeyword,

  /// The `while` keyword token.
  whileKeyword,

  /// The end-of-file token.
  endOfFile;

  @override
  String toString() {
    return switch (this) {
      leftParenthesis => '(',
      rightParenthesis => ')',
      leftBracket => '[',
      rightBracket => ']',
      leftBrace => '{',
      rightBrace => '}',
      comma => ',',
      dot => '.',
      minus => '-',
      plus => '+',
      semicolon => ';',
      slash => '/',
      asterisk => '*',
      bang => '!',
      bangEqual => '!=',
      equal => '=',
      equalEqual => '!=',
      greater => '>',
      greaterEqual => '>=',
      less => '<',
      lessEqual => '<=',
      leftArrow => '←',
      rightArrow => '→',
      fatRightArrow => '⇒',
      pipeToken => '|',
      colon => ':',
      doubleColon => '::',
      product => '×',
      identifier => 'identifier',
      string => 'string',
      symbol => "'",
      integer => 'integer',
      double => 'double',
      andKeyword => 'and',
      classKeyword => 'class',
      elseKeyword => 'else',
      falseKeyword => 'false',
      fnKeyword => 'ƒ',
      forKeyword => 'for',
      ifKeyword => 'if',
      unlessKeyword => 'unless',
      orKeyword => 'or',
      superKeyword => 'super',
      thisKeyword => 'this',
      trueKeyword => 'true',
      letKeyword => 'let',
      typeKeyword => 'type',
      typealiasKeyword => 'typealias',
      inKeyword => 'in',
      whileKeyword => 'while',
      endOfFile => 'EOF',
    };
  }
}
