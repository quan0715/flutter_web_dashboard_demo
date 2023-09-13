import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class DashboardConfigView extends StatefulWidget{
  const DashboardConfigView({Key? key}) : super(key: key);

  @override
  State<DashboardConfigView> createState() => _DashboardConfigViewState();
}

class _DashboardConfigViewState extends State<DashboardConfigView> {
  Widget configRowTemplate({required String title,required String description, required Widget child}){
    Widget titleAndSubTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: DashboardText.titleLarge(context)),
        Text(description, style: DashboardText.bodyMedium(context).copyWith(
          color: DashboardColor.secondary(context)
        ),),
      ],
    );
    Widget childWidget = SizedBox(
      width: 250,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: child,
        ),
      ),
    );
    return DashboardPadding.object(
      // padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if(constraints.maxWidth > 560){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleAndSubTitle,
                    childWidget
                  ],
                );
              }else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleAndSubTitle,
                    const SizedBox(height: 10,),
                    childWidget
                  ],
                );
              }
              
            }
          ),
          const Divider(),
        ],
      ),
    );
  }

  
  Widget settingToolBar(){
    Widget toolButtons = Row(
      children: [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 1,
              textStyle: DashboardText.titleSmall(context),
              foregroundColor: DashboardColor.error(context),
            ),
            onPressed: () => {},
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Text('Reset')),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 5,),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 1,
              textStyle: DashboardText.titleSmall(context),
              foregroundColor: DashboardColor.primary(context),
            ),
            onPressed: () => {},
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Text('儲存')),
            icon: const Icon(Icons.save),
          )
      ],
    );
    return DashboardPadding.object(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constrains) {
              if(constrains.maxWidth > 420){
                return Row(
                    children: [
                      Text('帳號設定', style: DashboardText.headLineSmall(context),),
                      const Spacer(),
                      toolButtons,
                      
                    ],
                );
              } else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('帳號設定', style: DashboardText.headLineSmall(context),),
                    SizedBox(height: 10,),
                    toolButtons, 
                  ]);
            }
            }
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(title: "帳戶設定"),
      drawer: const DashboardDrawer(),
      body: DashboardPadding.large(
        child: DashboardFrameCard(
          child: SizedBox.expand(
            child: DashboardPadding.object(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    settingToolBar(),
                    configRowTemplate(
                      title: 'SCADA Cycle Interval 監測週期',
                      description: '監測資料搜集最小時間單位',
                      child: DropdownButton(
                          underline: Container(),
                          value: 1,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(child: Text('10 分鐘每次'), value: 1,),
                            DropdownMenuItem(child: Text('15 分鐘每次'), value: 2,),
                            DropdownMenuItem(child: Text('20 分鐘每次'), value: 3,),
                            DropdownMenuItem(child: Text('30 分鐘每次'), value: 4,),
                          ],
                          onChanged: (value) => {},
                        ),
                    ),
                    configRowTemplate(
                      title: 'Rate Type 尖峰時段類型',
                      description: '設定固定或動態尖峰時段',
                      child: DropdownButton(
                          underline: Container(),
                          value: 1,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(child: Text('Fix 固定時段'), value: 1,),
                            DropdownMenuItem(child: Text('Dynamic 動態時段'), value: 2,),
                          ],
                          onChanged: (value) => {},
                        ),
                    ),
                    configRowTemplate(
                      title: 'Rate Type 尖峰時段分段方式',
                      description: '設定兩節或三節式計價電費',
                      child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return DropdownButton(
                              underline: Container(),
                              value: 1,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(child: Text('兩節式電費'), value: 1,),
                                DropdownMenuItem(child: Text('三節式電費'), value: 2,),
                              ],
                              onChanged: (value) => {},
                          );
                        }
                      )
                    ),
                    configRowTemplate(
                      title: 'Rate Type 用電類別',
                      description: '設定電壓分類 (高壓、特高壓)',
                      child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return DropdownButton(
                              underline: Container(),
                              value: 1,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(child: Text('高壓電 HV'), value: 1,),
                                DropdownMenuItem(child: Text('特高壓電 UHV'), value: 2,),
                              ],
                              onChanged: (value) => {},
                          );
                        }
                      )
                    ),
                    configRowTemplate(
                      title: 'Contract Capacity 契約容量',
                      description: '基礎電費支出計算依據',
                      child: TextField(
                        controller: TextEditingController(text: DashBoardFormat.number(10000)),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                          ),
                          labelText: '契約容量',
                          suffixText: 'kW',
                        ), 
                      )
                    ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}