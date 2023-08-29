import 'package:abstractions/beliefs.dart';

class NewObjectSameState<S extends CoreBeliefs> extends Conclusion<S> {
  @override
  S update(S state) {
    return (state as dynamic).copyWith() as S;
  }

  @override
  toJson() => {'name_': 'NoUpdateLandingMission', 'state_': {}};
}
