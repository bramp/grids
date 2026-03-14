/// Represents a distinct coordinate on the puzzle grid as a 1D index.
///
/// This is a zero-cost extension type over [int]. It provides type safety
/// for grid positions without the overhead of heap-allocating objects.
extension type const GridPoint(int value) implements int {
  /// Returns a human-readable representation (just the index).
  String get debugString => 'index:$value';
}
