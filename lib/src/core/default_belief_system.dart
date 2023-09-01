import 'dart:async';

import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:abstractions/beliefs.dart';
import 'package:abstractions/error_correction.dart';

import '../../percepts.dart';

typedef BeliefSystemFactory = BeliefSystem<S> Function<S extends CoreBeliefs>(
    BeliefSystem<S>, Consideration<S>);

/// Pass in [habits] to run logic on every [Cognition], before or after
/// [Consideration.consider] and/or [Conclusion.conclude] are called.
///
/// Make sure [onStateChangeController] is broadcast type as UI components will
/// listen for a time at random intervals and only want the state changes while
/// they are listening.
///
/// The [errorHandlers] parameter takes an object of type [ErrorHandlers] which
/// will be act on anything that gets thrown while executing
/// [Conclusion.conclude] or [Consideration.consider]. If no
/// object is passed, the Throwable is just rethrown, keeping the same stack
/// trace which is very useful in debugging.
class DefaultBeliefSystem<S extends CoreBeliefs> implements BeliefSystem<S> {
  DefaultBeliefSystem({
    required S beliefs,
    ErrorHandlers<S>? errorHandlers,
    StreamController<S>? onBeliefUpdateController,
    Habits? habits,
    BeliefSystemFactory? beliefSystemFactory,
  })  : _beliefs = beliefs,
        _errorHandlers = errorHandlers,
        _habits = habits ?? DefaultHabits(),
        _beliefSystemFactory = beliefSystemFactory;
  S _beliefs;
  final ErrorHandlers? _errorHandlers;

  /// This member is a constructor for creating special BeliefSystem objects,
  /// allowing for different behaviour under different circumstances - eg.
  /// when the Inspector is being used, extra information (such as the parent
  /// mission) can be added by the special BeliefSystem
  final BeliefSystemFactory? _beliefSystemFactory;

  final StreamController<S> _onBeliefUpdateController =
      StreamController<S>.broadcast();

  /// [Habit]s are called with every cognitive process, before [Consideration.consider]
  /// is called and/or after [Conclusion.conclude] is called.
  final Habits _habits;

  /// Returns the current state tree of the application.
  @override
  S get beliefs => _beliefs;

  /// A stream of the belief updates - the design of perception intends that your
  /// app would not need to use this stream directly but we expose it for edge
  /// cases.
  Stream<S> get beliefUpdates => _onBeliefUpdateController.stream;

  /// A [Conclusion] is the only way to upate the beliefs held in the
  /// [BeliefSystem], so any data, whether from UI events, network callbacks, or
  /// other sources such as WebSockets needs to eventually update the [BeliefSystem]
  /// in order for a [StreamOfConsciousness] widget to infer a model that is passed
  /// on to child widget and eventually drawn on screen.
  /// Specifically, That means calling [BeliefSystem.conclude] with a [Conclusion]
  /// that describes the desired belief updates.
  @override
  void conclude(Conclusion<S> conclusion) {
    for (final habit in _habits.preConclusion) {
      habit(this, conclusion);
    }

    try {
      _beliefs = conclusion.conclude(_beliefs);
    } catch (thrown, trace) {
      if (_errorHandlers == null) rethrow;
      _errorHandlers!.handleErrorDuringConclusion(
        thrown: thrown,
        trace: trace,
        reportSettings: (thrown is PerceptionException)
            ? thrown.reportSettings
            : FeedbackSettings.detailedFeedback,
        conclusion: conclusion,
        beliefSystem: this,
      );
    }

    // emit the new state for any listeners (eg. StateStreamBuilder widgets)
    _onBeliefUpdateController.add(_beliefs);

    for (final systemCheck in _habits.postConclusion) {
      systemCheck(this, conclusion);
    }
  }

  /// Creation or retrieval of data that is asynchronous must be performed via
  /// an [Consideration]. If the desired end result is changing the app state,
  /// the [Consideration] should land a [Conclusion] when it is complete.
  @override
  Future<void> consider(Consideration<S> consideration) async {
    for (final systemCheck in _habits.preConsideration) {
      systemCheck(this, consideration);
    }

    try {
      if (_beliefSystemFactory != null) {
        await consideration
            .consider(_beliefSystemFactory!(this, consideration));
      } else {
        await consideration.consider(this);
      }
      for (final systemCheck in _habits.postConsideration) {
        systemCheck(this, consideration);
      }
    } catch (thrown, trace) {
      if (_errorHandlers == null) rethrow;
      _errorHandlers!.handleExceptionDuringConsideration(
        thrown: thrown,
        trace: trace,
        reportSettings: (thrown is PerceptionException)
            ? thrown.reportSettings
            : FeedbackSettings.detailedFeedback,
        consideration: consideration,
        beliefSystem: this,
      );

      // emit the new state for any listeners (eg. StateStreamBuilder widgets)
      _onBeliefUpdateController.add(_beliefs);
    }
  }

  @override
  Stream<S> get onBeliefUpdate => _onBeliefUpdateController.stream;
}
