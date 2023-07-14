class ElectricityAmountProportion{
  final String name;
  final int amount;
  final double proportion;

  ElectricityAmountProportion({
    required this.name,required this.amount,required this.proportion
  });
  static int countAmount(List<ElectricityAmountProportion> data){
    int total = 0;
    for(int i = 0; i < data.length; i++){
      total += data[i].amount;
    }
    return total;
  } 

  static List<ElectricityAmountProportion> generateFakeData() {
    List<ElectricityAmountProportion> data = [];
    ElectricityAmountProportion data1 = ElectricityAmountProportion(
      name: '廠務',
      amount: 1021024,
      proportion: 0.5,
    );
    data.add(data1);
    ElectricityAmountProportion data2 = ElectricityAmountProportion(
      name: '產線',
      amount: 512123,
      proportion: 0.3,
    );
    data.add(data2);
    ElectricityAmountProportion data3 = ElectricityAmountProportion(
      name: '其他',
      amount: 512123,
      proportion: 0.2,
    );
    data.add(data3);
    return data;
  }

  static List<ElectricityAmountProportion> generateFakeData1() {
    List<ElectricityAmountProportion> data = [];
    ElectricityAmountProportion data1 = ElectricityAmountProportion(
      name: '區域1',
      amount: 31024,
      proportion: 0.2,
    );
    data.add(data1);
    ElectricityAmountProportion data2 = ElectricityAmountProportion(
      name: '區域2',
      amount: 51123,
      proportion: 0.1,
    );
    data.add(data2);
    ElectricityAmountProportion data3 = ElectricityAmountProportion(
      name: '區域3',
      amount: 42123,
      proportion: 0.7,
    );
    data.add(data3);
    return data;
  }

  static List<ElectricityAmountProportion> generateFakeData2() {
    List<ElectricityAmountProportion> data = [];
    ElectricityAmountProportion data1 = ElectricityAmountProportion(
      name: '產線1',
      amount: 21024,
      proportion: 0.3,
    );
    data.add(data1);
    ElectricityAmountProportion data2 = ElectricityAmountProportion(
      name: '產線2',
      amount: 78243,
      proportion: 0.3,
    );
    data.add(data2);
    ElectricityAmountProportion data3 = ElectricityAmountProportion(
      name: '產線3',
      amount: 22123,
      proportion: 0.4,
    );
    data.add(data3);
    return data;
  }
  
}


