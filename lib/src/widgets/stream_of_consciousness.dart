import 'dart:async';

import 'package:locator_for_perception/locator_for_perception.dart';
import 'package:flutter/widgets.dart';
import 'package:abstractions/beliefs.dart';

import 'errors/infer_function_failure.dart';

class StreamOfConsciousness<S extends CoreBeliefs, VM> extends StatelessWidget {
  final VM Function(S beliefs) infer;
  final Widget Function(BuildContext context, VM vm) builder;
  final void Function(BeliefSystem<S> beliefSystem)? onInit;
  final void Function(BeliefSystem<S> beliefSystem)? onDispose;

  const StreamOfConsciousness({
    Key? key,
    required this.infer,
    required this.builder,
    this.onInit,
    this.onDispose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StreamOfConsciousness<S, VM>(
      beliefSystem: locate<BeliefSystem<S>>(),
      builder: builder,
      inferer: infer,
      onInit: onInit,
      onDispose: onDispose,
    );
  }
}

class _StreamOfConsciousness<S extends CoreBeliefs, VM> extends StatefulWidget {
  final BeliefSystem<S> beliefSystem;
  final Widget Function(BuildContext, VM) builder;
  final VM Function(S) inferer;
  final void Function(BeliefSystem<S>)? onInit;
  final void Function(BeliefSystem<S>)? onDispose;

  const _StreamOfConsciousness({
    Key? key,
    required this.beliefSystem,
    required this.inferer,
    required this.builder,
    this.onInit,
    this.onDispose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StreamOfConsciousnessState<S, VM>();
  }
}

class _StreamOfConsciousnessState<S extends CoreBeliefs, VM>
    extends State<_StreamOfConsciousness<S, VM>> {
  late Stream<VM> _stream;
  VM? _previous;
  Object? _latestError;

  // `_latestValue!` would throw _CastError if `VM` is nullable,
  // therefore `_latestValue as VM` is used.
  // https://dart.dev/null-safety/understanding-null-safety#nullability-and-generics
  VM get _requireLatestValue => _previous as VM;

  @override
  void initState() {
    super.initState();

    widget.onInit?.call(widget.beliefSystem);

    _computeLatestValue();
    _createStream();
  }

  @override
  void dispose() {
    widget.onDispose?.call(widget.beliefSystem);
    super.dispose();
  }

  @override
  void didUpdateWidget(_StreamOfConsciousness<S, VM> oldWidget) {
    _computeLatestValue();

    if (widget.beliefSystem != oldWidget.beliefSystem) {
      _createStream();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _computeLatestValue() {
    try {
      _latestError = null;
      _previous = widget.inferer(widget.beliefSystem.beliefs);
    } catch (e, s) {
      _previous = null;
      _latestError = InferFunctionFailure(e, s);
    }
  }

  void _createStream() {
    _stream = widget.beliefSystem.onBeliefUpdate
        .map((_) => widget.inferer(widget.beliefSystem.beliefs))
        .transform(StreamTransformer.fromHandlers(
            handleError: _handleTransformFailure))
        .where((vm) => vm != _previous)
        .transform(StreamTransformer.fromHandlers(handleData: _updatePrevious))
        .transform(StreamTransformer.fromHandlers(handleError: _handleError));
  }

  void _handleTransformFailure(
    Object error,
    StackTrace stackTrace,
    EventSink<VM> sink,
  ) {
    sink.addError(InferFunctionFailure(error, stackTrace), stackTrace);
  }

  // After each VM is emitted from the Stream, we update the
  // latestValue. Important: This must be done after all other optional
  // transformations, such as ignoreChange.
  void _updatePrevious(VM vm, EventSink<VM> sink) {
    _latestError = null;
    _previous = vm;
    sink.add(vm);
  }

  // Handle any errors from inferer/onWillChange/onDidChange
  void _handleError(
    Object error,
    StackTrace stackTrace,
    EventSink<VM> sink,
  ) {
    _previous = null;
    _latestError = error;
    sink.addError(error, stackTrace);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VM>(
      stream: _stream,
      builder: (context, snapshot) {
        if (_latestError != null) throw _latestError!;

        return widget.builder(context, _requireLatestValue);
      },
    );
  }
}
