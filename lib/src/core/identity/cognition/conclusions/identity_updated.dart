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
    // Create new identity components
    final Map<IdentityProvider, String> newCredentials =
        _credentials ?? (beliefs as IdentityConcept).identity.credentials;
    final DefaultUserAuthState newAuthState = _userAuthState ??
        (beliefs as IdentityConcept).identity.userAuthState
            as DefaultUserAuthState;

    // Create new identity
    final IdentityBeliefs newIdentity = DefaultIdentityBeliefs(
        credentials: newCredentials, userAuthState: newAuthState);

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
