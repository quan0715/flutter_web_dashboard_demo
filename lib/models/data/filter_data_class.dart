class LayerFilterData<T>{
  T layerLabel;
  T layerSelectedIndex;
  T layerIndex;
  List<T> indexes;
  // Function<bool>(dynamic,dynamic) layerSelectedValidator;
  LayerFilterData({
    required this.layerLabel,
    required this.layerSelectedIndex,
    required this.layerIndex,
    this.indexes = const [],
    // required this.layerSelectedValidator,
  });
}