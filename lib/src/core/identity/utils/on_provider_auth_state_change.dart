import 'package:abstractions/beliefs.dart';
import 'package:types_for_auth/types_for_auth.dart';

class OnProviderAuthStateChange<S extends CoreBeliefs> {
  OnProviderAuthStateChange({
    List<Consideration<S>>? considerOnSignedIn,
    List<Conclusion<S>>? concludeOnSignedIn,
    List<Consideration<S>>? considerOnSignedOut,
    List<Conclusion<S>>? concludeOnSignedOut,
  })  : _considerOnSignedIn = considerOnSignedIn ?? [],
        _concludeOnSignedIn = concludeOnSignedIn ?? [],
        _considerOnSignedOut = considerOnSignedOut ?? [],
        _concludeOnSignedOut = concludeOnSignedOut ?? [];

  final List<Consideration<S>> _considerOnSignedIn;
  final List<Conclusion<S>> _concludeOnSignedIn;
  final List<Consideration<S>> _considerOnSignedOut;
  final List<Conclusion<S>> _concludeOnSignedOut;

  List<Consideration<S>> get considerOnSignedIn => _considerOnSignedIn;
  List<Conclusion<S>> get concludeOnSignedIn => _concludeOnSignedIn;
  List<Consideration<S>> get considerOnSignedOut => _considerOnSignedOut;
  List<Conclusion<S>> get concludeOnSignedOut => _concludeOnSignedOut;

  void add(
      {List<Consideration<S>>? considerOnSignedIn,
      List<Conclusion<S>>? concludeOnSignedIn,
      List<Consideration<S>>? considerOnSignedOut,
      List<Conclusion<S>>? concludeOnSignedOut}) {
    _considerOnSignedIn.addAll(considerOnSignedIn ?? []);
    _concludeOnSignedIn.addAll(concludeOnSignedIn ?? []);
    _considerOnSignedOut.addAll(considerOnSignedOut ?? []);
    _concludeOnSignedOut.addAll(concludeOnSignedOut ?? []);
  }

  /// [Consideration]s, which are async, are launched before [Conclusion]s
  /// so the [Consideration]s aren't held up by the [Conclusion]s.
  void runAll(SignedInState newSignedInState, BeliefSystem beliefSystem) {
    if (newSignedInState == SignedInState.signedIn) {
      for (final consideration in considerOnSignedIn) {
        beliefSystem.consider(consideration);
      }
      for (final conclusion in concludeOnSignedIn) {
        beliefSystem.conclude(conclusion);
      }
    } else if (newSignedInState == SignedInState.notSignedIn) {
      for (final consideration in considerOnSignedOut) {
        beliefSystem.consider(consideration);
      }
      for (final conclusion in concludeOnSignedOut) {
        beliefSystem.conclude(conclusion);
      }
    }
  }
}
