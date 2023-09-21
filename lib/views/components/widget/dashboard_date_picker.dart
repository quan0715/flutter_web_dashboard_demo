import 'package:flutter/material.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class DashboardDatePicker extends StatelessWidget{
  DashboardDatePicker({
    super.key,
    required this.initDate,
    required this.onDateChange,
    this.buttonLabel = "選擇時間",
  });
  final DateTime initDate;
  final Function(DateTime) onDateChange;
  final String buttonLabel;
  final GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        key: buttonKey,
        onPressed: ()async{
          final buttonPosition = buttonKey.currentContext!.findRenderObject() as RenderBox;
          final DateTime? result = await showDialog(
            context: context, 
            barrierDismissible: true,
            barrierLabel: "時間篩選",
            // barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return LayoutBuilder(
                builder: (context, constrain) {
                  Widget datePicker = DatePickerDialog(
                      initialDate: initDate,
                      firstDate: initDate.subtract(const Duration(days: 365)), 
                      lastDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      helpText: "選擇觀測區間",
                      cancelText: "取消",
                      confirmText: "確認",
                  );
                  if(constrain.maxWidth > 600){
                    return Stack(
                      children: [
                        Positioned(
                          top: buttonPosition.size.height + buttonPosition.localToGlobal(Offset.zero).dy - 15,
                          left: buttonPosition.localToGlobal(Offset.zero).dx - 20,
                          child: datePicker,
                        ),
                      ],
                    );
                  }else{
                    return datePicker;
                  }
                }
              );
            },
          );
          // 
          if(result != null){
            onDateChange(result);
          }
        },
        child:RawChip(
          side: BorderSide.none,
          avatar: Icon(Icons.filter_list, color: DashboardColor.primary(context)),
          label: Text("$buttonLabel: ${DashBoardFormat.timePickerLabel(initDate)}")
        )
      );
  }
}
