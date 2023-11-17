import 'package:abstractions/beliefs.dart';
import 'package:abstractions/framing.dart';

class AuthGateLayer implements FramingLayer, CoreBeliefs {
  const AuthGateLayer();

  @override
  AuthGateLayer copyWith() => this;

  @override
  toJson() => {'type': 'AuthGatePageState'};
}
