import 'package:types_for_perception/beliefs.dart';

import '../example_exception.dart';

class ExampleAwayMission<S extends CoreBeliefs> extends AwayMission<S> {
  @override
  Future<void> flightPlan(MissionControl<S> missionControl) async {
    throw ExampleException();
  }

  @override
  toJson() => {'name_': 'ExampleAwayMission', 'state_': {}};
}
