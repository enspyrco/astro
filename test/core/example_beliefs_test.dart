import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test-doubles/example_beliefs.dart';
import '../test-doubles/identity_equivalence_beliefs.dart';

void main() {
  test('CoreBeliefs objects with the same state are equal', () {
    var a = ExampleBeliefs(
        error: const DefaultErrorCorrectionBeliefs(
            reports: [DefaultFeedback(message: 'message')]));
    var b = ExampleBeliefs(
        error: const DefaultErrorCorrectionBeliefs(
            reports: [DefaultFeedback(message: 'message')]));

    expect(a == b, true);
  });

  test('CoreBeliefs can be cloned with empty copyWith()', () {
    // When app state uses identity equivalence, cloned objects are not equal
    var c = IdentityEquivalenceBeliefs(
        error: const DefaultErrorCorrectionBeliefs(
            reports: [DefaultFeedback(message: 'message')]));
    var d = c.copyWith();

    expect(c == d, false);

    // When a CoreBeliefs object uses state-based equivalence, cloned objects are equal
    var a = ExampleBeliefs(
        error: const DefaultErrorCorrectionBeliefs(
            reports: [DefaultFeedback(message: 'message')]));
    var b = a.copyWith();

    expect(a == b, true);
  });
}
