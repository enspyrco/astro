import 'package:abstractions/beliefs.dart';

import '../example_exception.dart';

class ExampleConsideration<S extends CoreBeliefs> extends Consideration<S> {
  @override
  Future<void> consider(BeliefSystem<S> beliefSystem) async {
    throw ExampleException();
  }

  @override
  toJson() => {'name_': 'ExampleAwayMission', 'state_': {}};
}
