import 'package:flutter_test/flutter_test.dart';
import 'package:usago/core/utils/slug_utils.dart';

void main() {
  group('SlugUtils - generateFromText', () {
    test('should convert text to lowercase slug', () {
      final slug = SlugUtils.generateFromText('My Business');
      expect(slug, equals('my-business'));
    });

    test('should replace spaces with dashes', () {
      final slug = SlugUtils.generateFromText('Amazing Coffee Shop');
      expect(slug, equals('amazing-coffee-shop'));
    });

    test('should remove special characters', () {
      final slug = SlugUtils.generateFromText('Café & Restaurant!!!');
      expect(slug, equals('caf-restaurant'));
    });

    test('should handle multiple consecutive spaces', () {
      final slug = SlugUtils.generateFromText('My    Business    Name');
      expect(slug, equals('my-business-name'));
    });

    test('should remove leading and trailing spaces', () {
      final slug = SlugUtils.generateFromText('  My Business  ');
      expect(slug, equals('my-business'));
    });

    test('should handle Indonesian characters', () {
      final slug = SlugUtils.generateFromText('Toko Buku & Alat Tulis');
      expect(slug, equals('toko-buku-alat-tulis'));
    });

    test('should handle numbers', () {
      final slug = SlugUtils.generateFromText('Shop 123');
      expect(slug, equals('shop-123'));
    });

    test('should handle empty string', () {
      final slug = SlugUtils.generateFromText('');
      expect(slug, equals(''));
    });

    test('should truncate long text to 100 characters', () {
      final longText = 'A' * 150;
      final slug = SlugUtils.generateFromText(longText);
      expect(slug.length <= 100, isTrue);
    });
  });

  group('SlugUtils - isValidSlug', () {
    test('should return true for valid slug', () {
      expect(SlugUtils.isValidSlug('my-business'), isTrue);
      expect(SlugUtils.isValidSlug('shop-123'), isTrue);
      expect(SlugUtils.isValidSlug('abc'), isTrue);
    });

    test('should return false for empty slug', () {
      expect(SlugUtils.isValidSlug(''), isFalse);
    });

    test('should return false for slug with uppercase', () {
      expect(SlugUtils.isValidSlug('My-Business'), isFalse);
    });

    test('should return false for slug with spaces', () {
      expect(SlugUtils.isValidSlug('my business'), isFalse);
    });

    test('should return false for slug with special characters', () {
      expect(SlugUtils.isValidSlug('my-business!'), isFalse);
      expect(SlugUtils.isValidSlug('my_business'), isFalse);
      expect(SlugUtils.isValidSlug('my.business'), isFalse);
    });

    test('should return false for slug starting with dash', () {
      expect(SlugUtils.isValidSlug('-my-business'), isFalse);
    });

    test('should return false for slug ending with dash', () {
      expect(SlugUtils.isValidSlug('my-business-'), isFalse);
    });

    test('should return false for slug too short', () {
      expect(SlugUtils.isValidSlug('a'), isFalse);
    });

    test('should return false for slug too long', () {
      final longSlug = 'a' * 101;
      expect(SlugUtils.isValidSlug(longSlug), isFalse);
    });
  });

  group('SlugUtils - sanitize', () {
    test('should sanitize text to valid slug', () {
      final slug = SlugUtils.sanitize('My Amazing Business!!!');
      expect(slug, equals('my-amazing-business'));
      expect(SlugUtils.isValidSlug(slug), isTrue);
    });

    test('should remove consecutive dashes', () {
      final slug = SlugUtils.sanitize('my---business');
      expect(slug, equals('my-business'));
    });

    test('should remove leading and trailing dashes', () {
      final slug = SlugUtils.sanitize('---my-business---');
      expect(slug, equals('my-business'));
    });

    test('should handle mixed case and special chars', () {
      final slug = SlugUtils.sanitize('Café & Restaurant 2024!');
      expect(slug, equals('caf-restaurant-2024'));
      expect(SlugUtils.isValidSlug(slug), isTrue);
    });
  });

  group('SlugUtils - generateUnique', () {
    test('should return base slug if not in existing list', () {
      final slug = SlugUtils.generateUnique('my-business', []);
      expect(slug, equals('my-business'));
    });

    test('should append counter if slug exists', () {
      final existingSlugs = ['my-business'];
      final slug = SlugUtils.generateUnique('my-business', existingSlugs);
      expect(slug, equals('my-business-1'));
    });

    test('should increment counter for multiple conflicts', () {
      final existingSlugs = ['my-business', 'my-business-1', 'my-business-2'];
      final slug = SlugUtils.generateUnique('my-business', existingSlugs);
      expect(slug, equals('my-business-3'));
    });

    test('should handle large number of conflicts', () {
      final existingSlugs = List.generate(10, (i) => i == 0 ? 'test' : 'test-$i');
      final slug = SlugUtils.generateUnique('test', existingSlugs);
      expect(slug, equals('test-10'));
    });

    test('should throw error after 1000 attempts', () {
      final existingSlugs = List.generate(1001, (i) => i == 0 ? 'test' : 'test-$i');
      expect(
        () => SlugUtils.generateUnique('test', existingSlugs),
        throwsException,
      );
    });
  });
}
