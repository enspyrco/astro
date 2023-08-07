import 'package:types_for_perception/beliefs.dart';

class NewObjectSameState<S extends CoreBeliefs> extends LandingMission<S> {
  @override
  S landingInstructions(S state) {
    return (state as dynamic).copyWith() as S;
  }

  @override
  toJson() => {'name_': 'NoUpdateLandingMission', 'state_': {}};
}
