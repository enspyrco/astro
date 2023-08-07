import 'package:error_handling_for_perception/error_handling_for_perception.dart';
import 'package:types_for_perception/beliefs.dart';

class AddErrorReport<S extends CoreBeliefs> extends LandingMission<S> {
  @override
  S landingInstructions(S state) {
    var newState = (state as dynamic).copyWith(
        error: (state as dynamic).error.copyWith(reports: [
      const DefaultErrorReport(message: 'message'),
      ...(state as dynamic).error.reports as List<DefaultErrorReport>
    ]));
    return newState as S;
  }

  @override
  toJson() => {'name_': 'UpdatingLandingMission', 'state_': {}};
}
