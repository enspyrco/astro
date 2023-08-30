import 'package:abstractions/beliefs.dart';

import '../example_exception.dart';

class ThrowingLandingMission<S extends CoreBeliefs> extends Conclusion<S> {
  @override
  S conclude(S state) {
    throw ExampleException();
  }

  @override
  toJson() => {};
}
