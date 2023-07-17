import 'package:flutter/material.dart';
import 'package:prologium_project_demo/views/common/color.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
import 'package:prologium_project_demo/views/common/sizedbox.dart';
import 'package:prologium_project_demo/views/common/text.dart';

class FrameQuote extends StatelessWidget{
  const FrameQuote({
    super.key,
    required this.quoteText,
    this.color,
    this.style,
    this.child,
    this.notes,
    this.notesStyle,
  });
  final String quoteText;
  final Color? color;
  final TextStyle? style;
  final Widget? child;
  final String? notes;
  final TextStyle? notesStyle;

  

  @override
  Widget build(BuildContext context) {
    Color quoteColor = color ?? DashboardColor.primary(context);
    TextStyle textStyle = style ?? DashboardText.titleMedium(context);
    TextStyle notesStyle = this.notesStyle ?? DashboardText.bodySmall(context).copyWith(
      color: DashboardText.bodyMedium(context).color!.withOpacity(0.5),
    );
    return DashboardPadding.small(
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4.5,
              decoration: BoxDecoration(
                color: quoteColor,
                borderRadius: BorderRadius.circular(10),
              )
            ),
            DashboardSizedBox.small(),
            Expanded(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(quoteText,style: textStyle),
                      const Spacer(),
                      if(notes!=null) Text(notes!,style: notesStyle)
                    ],
                  ),   
                  // child !=null ? DashboardDivider.large() : const SizedBox(),
                  child ?? const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}