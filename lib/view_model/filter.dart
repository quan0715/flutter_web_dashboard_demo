abstract class ViewModelFilter<M> {
  M? value;
  // FilterOption filterOption = FilterOption.matchOnlyValue;
  List<M>? dataSource = [];
  Function(M)? onValueChange;

  ViewModelFilter({
    this.value,
    this.dataSource,
    this.onValueChange
  });

  get filter => (M element) => 
    element == value || value == "全";

  set valueAndNotify(M value){
    this.value = value;
    onValueChange?.call(value);
  }

}

// class 
