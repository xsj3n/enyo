// future already provides this for async functions,
// so this is more for outside of async method use
sealed class Result<V, E>
{
  const Result();

  factory Result.ok(V val) = Ok<V, E>;
  factory Result.err(E err) = Err<V, E>;
}

class Ok<V, E> extends Result<V, E> {
  final V val;
  const Ok(this.val);
}

class Err<V, E> extends Result<V, E> {
  final E err;
  const Err(this.err);

}