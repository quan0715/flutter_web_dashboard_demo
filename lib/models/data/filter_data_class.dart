class LayerFilterData<T>{
  T layerLabel;
  T layerSelectedIndex;
  T layerIndex;
  LayerFilterData({
    required this.layerLabel,
    required this.layerSelectedIndex,
    required this.layerIndex,
  });

  factory LayerFilterData.init({
    required T layerLabel,
    required T layerIndex,
    List<T> indexes = const [],
  }) => LayerFilterData(
    layerLabel: layerLabel,
    layerIndex: layerIndex,
    layerSelectedIndex: layerIndex,
  );
}