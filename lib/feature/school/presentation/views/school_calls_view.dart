import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/feature/school/presentation/views/widgets/school_calls_view_body.dart';
import 'package:flutter/material.dart';

import '../../../../core/core_widgets/my_tab_bar_view.dart';


class SchoolCallsView extends StatefulWidget {
  const SchoolCallsView({super.key});

  @override
  State<SchoolCallsView> createState() => _SchoolCallsViewState();
}
class _SchoolCallsViewState extends State<SchoolCallsView> {

  CallStatus callStatus = CallStatus.waiting;
  @override
  Widget build(BuildContext context) {
    return Column(
      children:
      [
        MyTabBarView(
          length: 3,
          onTab: (index)
          {
            if (index == 0)
            {
              callStatus = CallStatus.waiting;
            }
            else if(index == 1)
            {
              callStatus = CallStatus.accepted;
            }
            else
            {
              callStatus = CallStatus.rejected;
            }
            setState(() {});
          },
          tabs: [
            TabBarItem(
                selected: callStatus == CallStatus.waiting,
                label: 'Waiting'),
            TabBarItem(
                selected: callStatus == CallStatus.accepted,
                label: 'Accepted'),
            TabBarItem(
                selected: callStatus == CallStatus.rejected,
                label: 'Rejected'),
          ],
        ),
        Builder(
          builder: (BuildContext context)
          {
            return SchoolCallsViewBody(callStatus: callStatus,);
          },
        ),

      ],
    );
  }
}
