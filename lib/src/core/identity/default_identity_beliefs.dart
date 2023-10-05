import 'package:abstractions/beliefs.dart';
import 'package:abstractions/identity.dart';
import 'package:json_utils/json_utils.dart';

import 'default_user_auth_state.dart';

class DefaultIdentityBeliefs implements IdentityBeliefs, CoreBeliefs {
  const DefaultIdentityBeliefs(
      {required this.credentials, required this.userAuthState});

  static DefaultIdentityBeliefs get initial => const DefaultIdentityBeliefs(
        credentials: {},
        userAuthState: DefaultUserAuthState(),
      );

  @override
  final Map<IdentityProvider, String> credentials;
  @override
  final DefaultUserAuthState userAuthState;

  @override
  DefaultIdentityBeliefs copyWith({
    Map<IdentityProvider, String>? credentials,
    DefaultUserAuthState? userAuthState,
  }) =>
      DefaultIdentityBeliefs(
          credentials: credentials ?? this.credentials,
          userAuthState: userAuthState ?? this.userAuthState);

  @override
  JsonMap toJson() => {
        'credentials': credentials,
        'userAuthState': userAuthState.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      other is DefaultIdentityBeliefs &&
      other.userAuthState == userAuthState &&
      other.credentials == credentials;

  @override
  int get hashCode => Object.hash(credentials, userAuthState);
}
