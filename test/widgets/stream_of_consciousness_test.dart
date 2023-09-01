import 'package:percepts/percepts.dart';
import 'package:locator_for_perception/locator_for_perception.dart';
import 'package:abstractions/beliefs.dart';
import 'package:abstractions/error_correction.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_test/flutter_test.dart';

import '../test-doubles/example_beliefs.dart';
import '../test-doubles/identity_equivalence_beliefs.dart';
import '../test-doubles/cognition/add_error_report.dart';
import '../test-doubles/cognition/new_object_same_state.dart';

void main() {
  testWidgets('StreamOfConsciousness only builds on belief updates',
      (tester) async {
    // Setup objects under test & test doubles
    var appState = ExampleBeliefs.initial;
    var beliefSystem = DefaultBeliefSystem(beliefs: appState);

    Locator.add<BeliefSystem<ExampleBeliefs>>(beliefSystem);

    int i = 0;
    final widget = MaterialApp(
        home: StreamOfConsciousness<ExampleBeliefs, List<Feedback>>(
            infer: (state) => state.error.reports,
            builder: (context, vm) {
              return Text('builds: ${i++}, reports: ${vm.length}');
            }));

    await tester.pumpWidget(widget);

    expect(find.text('builds: 0, reports: 0'), findsOneWidget);

    beliefSystem.conclude(AddErrorReport<ExampleBeliefs>());
    await tester.pump();

    expect(find.text('builds: 1, reports: 1'), findsOneWidget);

    beliefSystem.conclude(NewObjectSameState<ExampleBeliefs>());
    await tester.pump();

    expect(find.text('builds: 1, reports: 1'), findsOneWidget);

    beliefSystem.conclude(AddErrorReport<ExampleBeliefs>());
    // notes on why we add a duration are below
    await tester.pump(const Duration(microseconds: 1));
    expect(find.text('builds: 2, reports: 2'), findsOneWidget);
  });

  testWidgets(
      'StreamOfConsciousness only builds on belief updates (with identity equivalence)',
      (tester) async {
    // Setup objects under test & test doubles
    var appState = IdentityEquivalenceBeliefs.initial;
    var beliefSystem = DefaultBeliefSystem(beliefs: appState);

    Locator.add<BeliefSystem<IdentityEquivalenceBeliefs>>(beliefSystem);

    int i = 0;
    final widget = MaterialApp(
        home: StreamOfConsciousness<IdentityEquivalenceBeliefs, List<Feedback>>(
            infer: (state) => state.error.reports,
            builder: (context, vm) {
              return Text('builds: ${i++}, reports: ${vm.length}');
            }));

    await tester.pumpWidget(widget);

    expect(find.text('builds: 0, reports: 0'), findsOneWidget);

    beliefSystem.conclude(AddErrorReport<IdentityEquivalenceBeliefs>());
    await tester.pump();

    expect(find.text('builds: 1, reports: 1'), findsOneWidget);

    beliefSystem.conclude(NewObjectSameState<IdentityEquivalenceBeliefs>());
    await tester.pump();

    expect(find.text('builds: 1, reports: 1'), findsOneWidget);

    beliefSystem.conclude(AddErrorReport<IdentityEquivalenceBeliefs>());
    // notes on why we add a duration are below
    await tester.pump(const Duration(microseconds: 1));
    expect(find.text('builds: 2, reports: 2'), findsOneWidget);
  });
}

// ** why we add a duration 
// adding a duration here does an extra microtask flush,  we can also call
// pump() twice, not sure why we need two flushes though, I guess the stream
// is behind?
