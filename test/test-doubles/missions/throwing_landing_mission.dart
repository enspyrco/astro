import 'package:types_for_perception/core_types.dart';
import 'package:types_for_perception/state_types.dart';

import '../example_exception.dart';

class ThrowingLandingMission<S extends AstroState> extends LandingMission<S> {
  @override
  S landingInstructions(S state) {
    throw ExampleException();
  }

  @override
  toJson() => {};
}
