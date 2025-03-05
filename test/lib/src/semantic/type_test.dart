import 'package:pinto/semantic.dart';
import 'package:test/test.dart';

void main() {
  const top = TopType();
  const bottom = BottomType();
  const unit = StructType.unit;
  const type = TypeType.self();
  final singleton = StructType.singleton;

  test('The top type is only the subtype of itself', () {
    final top = const TopType();
    expect(top < top, isTrue);
    expect(top < singleton(top), isTrue);
    expect(top < bottom, isFalse);
    expect(top < type, isFalse);
    expect(top < unit, isFalse);
  });

  test('The bottom type is the subtype of all types', () {
    expect(bottom < top, isTrue);
    expect(bottom < bottom, isTrue);
    expect(bottom < singleton(bottom), isTrue);
    expect(bottom < type, isTrue);
    expect(bottom < unit, isTrue);
  });

  test('A singleton struct is the subtype of its member type', () {
    expect(singleton(top) < top, isTrue);
    expect(singleton(unit) < unit, isTrue);
    expect(singleton(type) < type, isTrue);
    expect(singleton(bottom) < bottom, isTrue);
  });

  test('A type is subytpe of their counterpart singleton struct', () {
    expect(top < singleton(top), isTrue);
    expect(unit < singleton(unit), isTrue);
    expect(type < singleton(type), isTrue);
    expect(bottom < singleton(bottom), isTrue);
  });
}
