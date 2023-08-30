import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:abstractions/beliefs.dart';

class AddErrorReport<S extends CoreBeliefs> extends Conclusion<S> {
  @override
  S conclude(S state) {
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
