import 'package:types_for_perception/core_types.dart';
import 'package:types_for_perception/state_types.dart';

import '../example_exception.dart';

class ExampleAwayMission<S extends AstroState> extends AwayMission<S> {
  @override
  Future<void> flightPlan(MissionControl<S> missionControl) async {
    throw ExampleException();
  }

  @override
  toJson() => {'name_': 'ExampleAwayMission', 'state_': {}};
}
