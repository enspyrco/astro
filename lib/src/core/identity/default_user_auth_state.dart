import 'package:abstractions/beliefs.dart';
import 'package:types_for_auth/types_for_auth.dart';

class DefaultUserAuthState implements UserAuthState, CoreBeliefs {
  const DefaultUserAuthState({
    this.signedIn = SignedInState.checking,
    this.uid,
    this.displayName,
    this.photoURL,
  });

  @override
  final SignedInState signedIn;
  @override
  final String? uid;
  @override
  final String? displayName;
  @override
  final String? photoURL;

  @override
  DefaultUserAuthState copyWith({
    SignedInState? signedIn,
    String? uid,
    String? displayName,
    String? photoURL,
  }) {
    return DefaultUserAuthState(
      signedIn: signedIn ?? this.signedIn,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? photoURL,
    );
  }

  @override
  toJson() => <String, dynamic>{
        'signedIn': signedIn.name,
        'uid': uid,
        'displayName': displayName,
        'photoUrl': photoURL,
      };

  @override
  bool operator ==(Object other) =>
      other is DefaultUserAuthState &&
      other.signedIn == signedIn &&
      other.uid == uid &&
      other.displayName == displayName &&
      other.photoURL == photoURL;

  @override
  int get hashCode => Object.hash(signedIn, uid, displayName, photoURL);
}
