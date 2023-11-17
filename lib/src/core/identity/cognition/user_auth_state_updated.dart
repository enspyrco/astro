import 'package:types_for_auth/types_for_auth.dart';
import 'package:abstractions/beliefs.dart';

class UserAuthStateUpdated<T extends CoreBeliefs> extends Conclusion<T> {
  const UserAuthStateUpdated(this.userAuthState);

  final UserAuthState userAuthState;

  @override
  T conclude(T beliefs) {
    return (beliefs as dynamic).copyWith(
        identity: (beliefs as dynamic)
            .identity
            .copyWith(userAuthState: userAuthState)) as T;
  }

  @override
  toJson() => {
        'name_': 'UserAuthStateUpdated',
        'state_': {
          'user': {
            'signedIn': userAuthState.signedIn,
            'displayName': userAuthState.displayName,
            'photoURL': userAuthState.photoURL,
            'uid': userAuthState.uid,
          }
        }
      };
}
