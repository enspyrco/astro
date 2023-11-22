import 'package:types_for_auth/types_for_auth.dart';
import 'package:abstractions/beliefs.dart';

class UserAuthStateUpdated<T extends CoreBeliefs> extends Conclusion<T> {
  const UserAuthStateUpdated(this.signedIn);

  final SignedInState signedIn;

  @override
  T conclude(T beliefs) {
    dynamic oldUserAuthState = (beliefs as dynamic).identity.userAuthState;
    final newUserAuthstate =
        oldUserAuthState.copyWith(signedIn: signedIn) as UserAuthState;
    return (beliefs as dynamic).copyWith(
        identity: (beliefs as dynamic)
            .identity
            .copyWith(userAuthState: newUserAuthstate)) as T;
  }

  @override
  toJson() => {
        'name_': 'UserAuthStateUpdated',
        'state_': {
          'userAuthState': {
            'signedIn': signedIn,
          }
        }
      };
}
