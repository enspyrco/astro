import 'package:error_handling_for_perception/error_handling_for_perception.dart';
import 'package:types_for_perception/core_types.dart';
import 'package:types_for_perception/state_types.dart';

class AddErrorReport<S extends AstroState> extends LandingMission<S> {
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
