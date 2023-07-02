import 'package:types_for_perception/core_types.dart';
import 'package:types_for_perception/state_types.dart';

class NewObjectSameState<S extends AstroState> extends LandingMission<S> {
  @override
  S landingInstructions(S state) {
    return (state as dynamic).copyWith() as S;
  }

  @override
  toJson() => {'name_': 'NoUpdateLandingMission', 'state_': {}};
}
