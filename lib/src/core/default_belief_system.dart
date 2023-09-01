import 'dart:async';

import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:abstractions/beliefs.dart';
import 'package:abstractions/error_correction.dart';

import '../../percepts.dart';

typedef BeliefSystemFactory = BeliefSystem<S> Function<S extends CoreBeliefs>(
    BeliefSystem<S>, Consideration<S>);

/// Pass in [systemChecks] to run logic on every [Cognition], before or after
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
    required S state,
    ErrorHandlers<S>? errorHandlers,
    StreamController<S>? onStateChangeController,
    Habits? systemChecks,
    BeliefSystemFactory? beliefSystemFactory,
  })  : _state = state,
        _errorHandlers = errorHandlers,
        _systemChecks = systemChecks ?? DefaultHabits(),
        _beliefSystemFactory = beliefSystemFactory;
  S _state;
  final ErrorHandlers? _errorHandlers;

  /// This member is a constructor for creating special BeliefSystem objects,
  /// allowing for different behaviour under different circumstances - eg.
  /// when the Inspector is being used, extra information (such as the parent
  /// mission) can be added by the special BeliefSystem
  final BeliefSystemFactory? _beliefSystemFactory;

  final StreamController<S> _onStateChangeController =
      StreamController<S>.broadcast();

  /// [Habit]s are called on every mission, before [Consideration.consider]
  /// is called and after [Conclusion.conclude] is called.
  final Habits _systemChecks;

  /// Returns the current state tree of the application.
  @override
  S get beliefs => _state;

  /// A stream of the app state changes - the design of astro intends that your
  /// app would not need to use this stream directly but we expose it for edge
  /// cases.
  Stream<S> get stateChanges => _onStateChangeController.stream;

  /// Landing a [Conclusion] is the only way to upate the state held in
  /// BeliefSystem, so any data, whether from UI events, network callbacks, or other
  /// sources such as WebSockets needs to eventually be landed (ie. call land on
  /// [Conclusion] that described the desired state change).
  @override
  void conclude(Conclusion<S> mission) {
    for (final systemCheck in _systemChecks.preConclusion) {
      systemCheck(this, mission);
    }

    try {
      _state = mission.conclude(_state);
    } catch (thrown, trace) {
      if (_errorHandlers == null) rethrow;
      _errorHandlers!.handleLandingError(
        thrown: thrown,
        trace: trace,
        reportSettings: (thrown is PerceptionException)
            ? thrown.reportSettings
            : ErrorReportSettings.fullReport,
        mission: mission,
        beliefSystem: this,
      );
    }

    // emit the new state for any listeners (eg. StateStreamBuilder widgets)
    _onStateChangeController.add(_state);

    for (final systemCheck in _systemChecks.postConclusion) {
      systemCheck(this, mission);
    }
  }

  /// Creation or retrieval of data that is asynchronous must be performed via
  /// an [Consideration]. If the desired end result is changing the app state,
  /// the [Consideration] should land a [Conclusion] when it is complete.
  @override
  Future<void> consider(Consideration<S> mission) async {
    for (final systemCheck in _systemChecks.preConsideration) {
      systemCheck(this, mission);
    }

    try {
      if (_beliefSystemFactory != null) {
        await mission.consider(_beliefSystemFactory!(this, mission));
      } else {
        await mission.consider(this);
      }
      for (final systemCheck in _systemChecks.postConsideration) {
        systemCheck(this, mission);
      }
    } catch (thrown, trace) {
      if (_errorHandlers == null) rethrow;
      _errorHandlers!.handleLaunchError(
        thrown: thrown,
        trace: trace,
        reportSettings: (thrown is PerceptionException)
            ? thrown.reportSettings
            : ErrorReportSettings.fullReport,
        mission: mission,
        beliefSystem: this,
      );

      // emit the new state for any listeners (eg. StateStreamBuilder widgets)
      _onStateChangeController.add(_state);
    }
  }

  @override
  Stream<S> get onBeliefUpdate => _onStateChangeController.stream;
}
