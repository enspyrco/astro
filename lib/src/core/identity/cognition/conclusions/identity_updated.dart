import 'package:abstractions/beliefs.dart';
import 'package:abstractions/identity.dart';

import '../../default_identity_beliefs.dart';
import '../../default_user_auth_state.dart';

class IdentityUpdated<T extends CoreBeliefs> extends Conclusion<T> {
  const IdentityUpdated(
      {Map<IdentityProvider, String>? credentials,
      DefaultUserAuthState? userAuthState})
      : _userAuthState = userAuthState,
        _credentials = credentials;

  final DefaultUserAuthState? _userAuthState;
  final Map<IdentityProvider, String>? _credentials;

  @override
  T conclude(T beliefs) {
    final IdentityBeliefs newIdentity = DefaultIdentityBeliefs(
        credentials: _credentials ??
            (beliefs as dynamic).identity.credentials
                as Map<IdentityProvider, String>,
        userAuthState: _userAuthState ??
            (beliefs as dynamic).identity.userAuthState
                as DefaultUserAuthState);
    return (beliefs as dynamic).copyWith(identity: newIdentity) as T;
  }

  @override
  toJson() => {
        'name_': 'UpdateIdentity',
        'state_': {
          'userAuthState': _userAuthState?.toJson(),
          'credentials': _credentials,
        }
      };
}
