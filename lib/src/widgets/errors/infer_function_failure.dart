/// Thrown when the StreamOfConsciousness encounters a problem while
/// running the [StreamOfConsciousness.infer] function.
class InferFunctionFailure implements Error {
  final Object error;
  final StackTrace trace;
  InferFunctionFailure(this.error, this.trace);

  @override
  String toString() {
    return '''Infer Function Failure: If the infer function passed
to a StreamOfConsciousness widget throws when applied, we wrap what was
thrown in an InferFunctionFailure. Below is what was originally thrown:

$error
    
$trace

''';
  }

  @override
  StackTrace? get stackTrace => trace;
}
