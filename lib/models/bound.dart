class BoundDataClass{
  final int? lowerBound;  // lower bound
  final int? upperBound;  // upper bound
  final int? warningUpperBound; // warning upper bound
  final int? warningLowerBound; // warning lower bound
  // constructor
  BoundDataClass({
    this.lowerBound,
    this.upperBound,
    this.warningUpperBound,
    this.warningLowerBound,
  });
  @override
  String toString() {
    return "| lb: $lowerBound | ub: $upperBound | wub: $warningUpperBound | wlb: $warningLowerBound |";
  }
}