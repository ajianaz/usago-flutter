import 'package:flutter_test/flutter_test.dart';
import 'package:usago/shared/utils/animation_utils.dart' as animation_utils;
import 'package:usago/shared/themes/animation_theme.dart' as animation_theme;

void main() {
  group('ShakeCurve Tests', () {
    test('AnimationUtils ShakeCurve should map 1.0 to near 1.0', () {
      final curve = animation_utils.ShakeCurve();

      // Test key points
      expect(curve.transform(0.0), closeTo(0.0, 0.01));
      expect(curve.transform(0.5), closeTo(0.5, 0.1)); // At t=0.5, should be near 0.5
      expect(curve.transform(1.0), equals(1.0)); // Should be exactly 1.0, not -0.0 or 0.0

      // Test that the curve produces reasonable values
      for (double t = 0.0; t <= 1.0; t += 0.1) {
        final value = curve.transform(t);
        expect(value, greaterThanOrEqualTo(0.0)); // Should be non-negative
        expect(value, lessThanOrEqualTo(1.1)); // Should be within reasonable bounds
      }
    });

    test('AnimationTheme ShakeCurve should map 1.0 to near 1.0', () {
      final curve = animation_theme.ShakeCurve();

      // Test key points
      expect(curve.transform(0.0), closeTo(0.0, 0.01));
      expect(curve.transform(0.5), closeTo(0.5, 0.1)); // At t=0.5, should be near 0.5
      expect(curve.transform(1.0), equals(1.0)); // Should be exactly 1.0, not -0.0 or 0.0

      // Test that the curve produces reasonable values
      for (double t = 0.0; t <= 1.0; t += 0.1) {
        final value = curve.transform(t);
        expect(value, greaterThanOrEqualTo(0.0)); // Should be non-negative
        expect(value, lessThanOrEqualTo(1.1)); // Should be within reasonable bounds
      }
    });

    test('ShakeCurve should produce shake effect', () {
      final curve = animation_utils.ShakeCurve();

      // The curve should oscillate (shake) while damping
      final values = <double>[];
      for (double t = 0.0; t <= 1.0; t += 0.05) {
        values.add(curve.transform(t));
      }

      // Check that values vary (shake effect)
      final minValue = values.reduce((a, b) => a < b ? a : b);
      final maxValue = values.reduce((a, b) => a > b ? a : b);

      // The curve should have variation (not just be linear)
      expect(maxValue - minValue, greaterThan(0.1));

      // Should end at 1.0
      expect(curve.transform(1.0), equals(1.0));

      // Should start at 0.0
      expect(curve.transform(0.0), closeTo(0.0, 0.01));
    });
  });
}