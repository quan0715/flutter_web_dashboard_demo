

enum WorkspaceType {
  factory('全廠區'), factoryService('廠務'), productionLine('產線'), others('其他');

  const WorkspaceType(this.label);
  
  final String label;
  
  static WorkspaceType getTypeByTitle(String title) =>
    WorkspaceType.values.firstWhere((workspaceType) => workspaceType.label == title);
  
  // static WorkspaceType getType(int number) => WorkspaceType.values.firstWhere((activity) => activity.number == number);

  // static String getValue(int number) => WorkspaceType.values.firstWhere((activity) => activity.number == number).value;
}