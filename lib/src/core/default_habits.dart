import 'package:abstractions/beliefs.dart';

class DefaultHabits implements Habits {
  DefaultHabits();

  @override
  final List<Habit> preConsideration = [];
  @override
  final List<Habit> postConsideration = [];
  @override
  final List<Habit> preConclusion = [];
  @override
  final List<Habit> postConclusion = [];
}
