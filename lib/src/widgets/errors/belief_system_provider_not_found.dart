import 'package:abstractions/beliefs.dart';

class BeliefSystemProviderNotFound<S extends CoreBeliefs> extends Error {
  BeliefSystemProviderNotFound();

  @override
  String toString() {
    return '''Error: No BeliefSystemProvider<$S> found. Try:
          
  * Move the BeliefSystemProvider<$S> higher in the widget tree, above
    where it is first used (eg. by a context.launch call)
  * Provide full type information to BeliefSystem<$S>, BeliefSystemProvider<$S>
    and StreamOfConsciousness<$S, VM>
  * Move the BeliefSystemProvider<$S> above MaterialApp if the Navigator
    may be changing the widget tree, taking out the BeliefSystemProvider<$S>
''';
  }
}
