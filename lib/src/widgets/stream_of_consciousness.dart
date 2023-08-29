import 'dart:async';

import 'package:locator_for_perception/locator_for_perception.dart';
import 'package:flutter/widgets.dart';
import 'package:abstractions/beliefs.dart';

import 'exceptions/transform_failure_exception.dart';

class StreamOfConsciousness<S extends CoreBeliefs, VM> extends StatelessWidget {
  final VM Function(S belief) infer;
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
    return _OnStateChangeBuilder<S, VM>(
      beliefSystem: locate<BeliefSystem<S>>(),
      builder: builder,
      transformer: infer,
      onInit: onInit,
      onDispose: onDispose,
    );
  }
}

class _OnStateChangeBuilder<S extends CoreBeliefs, VM> extends StatefulWidget {
  final BeliefSystem<S> beliefSystem;
  final Widget Function(BuildContext, VM) builder;
  final VM Function(S) transformer;
  final void Function(BeliefSystem<S>)? onInit;
  final void Function(BeliefSystem<S>)? onDispose;

  const _OnStateChangeBuilder({
    Key? key,
    required this.beliefSystem,
    required this.transformer,
    required this.builder,
    this.onInit,
    this.onDispose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OnStateChangeBuilderState<S, VM>();
  }
}

class _OnStateChangeBuilderState<S extends CoreBeliefs, VM>
    extends State<_OnStateChangeBuilder<S, VM>> {
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
  void didUpdateWidget(_OnStateChangeBuilder<S, VM> oldWidget) {
    _computeLatestValue();

    if (widget.beliefSystem != oldWidget.beliefSystem) {
      _createStream();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _computeLatestValue() {
    try {
      _latestError = null;
      _previous = widget.transformer(widget.beliefSystem.state);
    } catch (e, s) {
      _previous = null;
      _latestError = TransformFailureException(e, s);
    }
  }

  void _createStream() {
    _stream = widget.beliefSystem.onBeliefUpdate
        .map((_) => widget.transformer(widget.beliefSystem.state))
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
    sink.addError(TransformFailureException(error, stackTrace), stackTrace);
  }

  // After each VM is emitted from the Stream, we update the
  // latestValue. Important: This must be done after all other optional
  // transformations, such as ignoreChange.
  void _updatePrevious(VM vm, EventSink<VM> sink) {
    _latestError = null;
    _previous = vm;
    sink.add(vm);
  }

  // Handle any errors from transformer/onWillChange/onDidChange
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
