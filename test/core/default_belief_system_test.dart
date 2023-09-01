import 'package:percepts/percepts.dart';
import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test-doubles/example_beliefs.dart';
import '../test-doubles/example_exception.dart';
import '../test-doubles/cognition/add_error_report.dart';
import '../test-doubles/cognition/example_consideration.dart';
import '../test-doubles/cognition/new_object_same_state.dart';
import '../test-doubles/cognition/throwing_landing_mission.dart';

void main() {
  test('DefaultBeliefSystem rethrows errors when landing missions', () {
    // Setup objects under test & test doubles
    var exampleBeliefs = ExampleBeliefs.initial;
    var beliefSystem = DefaultBeliefSystem(beliefs: exampleBeliefs);
    var mission = ThrowingLandingMission<ExampleBeliefs>();

    // Check there are no error messages before we start
    expect(exampleBeliefs.error.reports, isEmpty);

    // Land the mission
    expect(
        () => beliefSystem.conclude(mission), throwsA(isA<ExampleException>()));
  });

  test('DefaultBeliefSystem rethrows errors when launching missions', () {
    // Setup objects under test & test doubles
    var exampleBeliefs = ExampleBeliefs.initial;
    var beliefSystem = DefaultBeliefSystem(beliefs: exampleBeliefs);
    var consideration = ExampleConsideration<ExampleBeliefs>();

    // Check there are no error messages before we start
    expect(exampleBeliefs.error.reports, isEmpty);

    // Set an expectation that BeliefSystem will emit an app state with an error message
    expect(
        beliefSystem.onBeliefUpdate,
        emits(predicate<ExampleBeliefs>(
            (appState) => appState.error.reports.isNotEmpty)));

    // Launch the mission
    beliefSystem.consider(consideration);
  });

  test('BeliefSystem emits onBeliefUpdate events only when state changes', () {
    // Setup objects under test & test doubles
    var appState = ExampleBeliefs.initial;
    var beliefSystem = DefaultBeliefSystem(beliefs: appState);

    // Check there are no error messages before we start
    // expect(appState.error.reports, isEmpty);

    // We expect that BeliefSystem will emit app states with the relevant error reports
    expect(
        beliefSystem.onBeliefUpdate,
        emitsInOrder([
          ExampleBeliefs(
              error: const DefaultErrorCorrectionBeliefs(
                  reports: [DefaultFeedback(message: 'message')])),
          ExampleBeliefs(
              error: const DefaultErrorCorrectionBeliefs(
                  reports: [DefaultFeedback(message: 'message')])),
          ExampleBeliefs(
              error: const DefaultErrorCorrectionBeliefs(reports: [
            DefaultFeedback(message: 'message'),
            DefaultFeedback(message: 'message')
          ]))
        ]));

    // Perform conclusions
    beliefSystem.conclude(AddErrorReport());
    beliefSystem.conclude(NewObjectSameState());
    beliefSystem.conclude(AddErrorReport());
  });
}
