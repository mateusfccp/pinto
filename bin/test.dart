final class Id {
  const Id({required this.id});

  final int id;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Id && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

final class Unit {
  const Unit();

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => runtimeType.hashCode;
}

sealed class Option<T> {}

final class Some<T> implements Option<T> {
  const Some({required this.value});

  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Some<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class None implements Option<Never> {
  const None();

  @override
  bool operator ==(Object other) => other is None;

  @override
  int get hashCode => runtimeType.hashCode;
}

sealed class LogLevel {}

final class Debug implements LogLevel {
  const Debug();

  @override
  bool operator ==(Object other) => other is Debug;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class Info implements LogLevel {
  const Info();

  @override
  bool operator ==(Object other) => other is Info;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class Warn implements LogLevel {
  const Warn();

  @override
  bool operator ==(Object other) => other is Warn;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class Error implements LogLevel {
  const Error();

  @override
  bool operator ==(Object other) => other is Error;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class Fatal implements LogLevel {
  const Fatal();

  @override
  bool operator ==(Object other) => other is Fatal;

  @override
  int get hashCode => runtimeType.hashCode;
}

sealed class Bool {}

final class True implements Bool {
  const True();

  @override
  bool operator ==(Object other) => other is True;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class False implements Bool {
  const False();

  @override
  bool operator ==(Object other) => other is False;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class Two<T> {
  const Two({
    required this.a,
    required this.b,
  });

  final T a;

  final T b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Two<T> && other.a == a && other.b == b;
  }

  @override
  int get hashCode => Object.hash(
        a,
        b,
      );
}

final class Many {
  const Many({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.f,
    required this.g,
    required this.h,
    required this.i,
    required this.j,
    required this.k,
    required this.l,
    required this.m,
    required this.n,
    required this.o,
    required this.p,
    required this.q,
    required this.r,
    required this.s,
    required this.t,
    required this.u,
    required this.v,
    required this.w,
    required this.x,
    required this.y,
    required this.z,
  });

  final int a;

  final int b;

  final int c;

  final int d;

  final int e;

  final int f;

  final int g;

  final int h;

  final int i;

  final int j;

  final int k;

  final int l;

  final int m;

  final int n;

  final int o;

  final int p;

  final int q;

  final int r;

  final int s;

  final int t;

  final int u;

  final int v;

  final int w;

  final int x;

  final int y;

  final int z;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Many &&
        other.a == a &&
        other.b == b &&
        other.c == c &&
        other.d == d &&
        other.e == e &&
        other.f == f &&
        other.g == g &&
        other.h == h &&
        other.i == i &&
        other.j == j &&
        other.k == k &&
        other.l == l &&
        other.m == m &&
        other.n == n &&
        other.o == o &&
        other.p == p &&
        other.q == q &&
        other.r == r &&
        other.s == s &&
        other.t == t &&
        other.u == u &&
        other.v == v &&
        other.w == w &&
        other.x == x &&
        other.y == y &&
        other.z == z;
  }

  @override
  int get hashCode => Object.hashAll([
        a,
        b,
        c,
        d,
        e,
        f,
        g,
        h,
        i,
        j,
        k,
        l,
        m,
        n,
        o,
        p,
        q,
        r,
        s,
        t,
        u,
        v,
        w,
        x,
        y,
        z,
      ]);
}
