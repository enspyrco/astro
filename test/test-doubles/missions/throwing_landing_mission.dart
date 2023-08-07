import 'package:types_for_perception/beliefs.dart';

import '../example_exception.dart';

class ThrowingLandingMission<S extends CoreBeliefs> extends LandingMission<S> {
  @override
  S landingInstructions(S state) {
    throw ExampleException();
  }

  @override
  toJson() => {};
}
