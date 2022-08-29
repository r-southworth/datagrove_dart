import 'package:stemmer/stemmer.dart';

class TokenType {
  static const eof = 0;
  static const reserved = 1;
  static const keyword = 2;
  static const range = 3;
  static const phrase = 4;
  static const lparen = 5;
  static const rparen = 6;
  static const or = 7;
  static const and = 8;
  static const hyphen = 9;
}

// keywords are
final keywords = {
  "define": 0, // lookup definition, unclear arity
  "site": 0,
  "inurl": 0,
  "allinurl": 0,
  "allintitle": 0,
  "intext": 0,
  "allintext": 0,
  "filetype": 0,
};

final reserved = {
  "and": 0,
  "or": 1,
  "near": 2,
  "range": 3,
  "around": 4, // this takes a (argument)
};

class Token {
  final int begin, end; // position in source

  final String symbol;
  final int type;
  final int arity;
  const Token(
      {required this.begin,
      required this.end,
      required this.type,
      this.symbol = "",
      this.arity = 0});

  static const eof = Token(
    begin: 0,
    end: 0,
    type: TokenType.eof,
  );

  static Token keyword(int begin, int end, String s) {
    return Token(begin: begin, end: end, symbol: s, type: TokenType.keyword);
  }

  static Token phrase(int begin, int end, String s) {
    // we should optimize the phrase here, stop words, stemming, etc.
    return Token(begin: begin, end: end, symbol: s, type: TokenType.phrase);
  }
}

PorterStemmer stemmer = PorterStemmer();

// we don't want to stem right away; this could be an address.
class Phrase {
  String s;

  Phrase(this.s) {}

  // split on hyphens or nah?
  List<String> stemmed() {
    // porter stemmer
    var w = s
        .toLowerCase()
        .split(" ")
        .map((String e) => stemmer.stem(e.trim()))
        .toList();
    return w;
  }
}

bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

bool isAlpha(String s) {
  return s.contains('[a-z]');
}

class Lexer {
  Token token = Token.eof;
  String source;
  var p = 0;
  bool inQuote = false;
  String error = "";

  Lexer(this.source) {
    source = source.toLowerCase();
    next();
  }
  bool match(TokenType x) {
    if (token.type == x) {
      next();
      return true;
    }
    return false;
  }

  takeNumber() {}

  // a word followed by an operator is a keyword, so look ahead
  // to see if its an op.
  String peek() {
    return "";
  }

  takeWord() {
    var e = p + 1;
    while (e < source.length && isAlpha(source[e])) {
      e++;
    }
    // check against the reserved words

    if (source[e] == ':') {
      token = Token.keyword(p, e, source.substring(p, e));
      p = e + 1;
    } else {
      token = Token.phrase(p, e, source.substring(p, e));
      p = e;
    }
  }

  next() {
    if (p >= source.length) {
      token = Token.eof;
    }
    while (p < source.length && source[p] == ' ') {
      p++;
    }

    switch (source[p]) {
      case "\"":
        int e = p;
        while (e < source.length && source[e] != '"') {
          e++;
        }
        token = Token.phrase(p + 1, e, source.substring(p + 1, e));
        p = e + 1; // this can be  end+1 if not matched quote, but caught above
        return;
      case "(":
      case "\$":
      case "€":
      case "|": // or
      case ")":
      case "-": // unary minus
      case "\$":
      default:
        takeWord();
    }
  }
}
