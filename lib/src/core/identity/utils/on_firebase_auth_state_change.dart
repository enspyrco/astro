import 'package:abstractions/beliefs.dart';

class OnFirebaseAuthStateChange<S extends CoreBeliefs> {
  OnFirebaseAuthStateChange({
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
}
