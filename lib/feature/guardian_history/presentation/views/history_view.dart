import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/feature/guardian_history/presentation/cubit/history/history_cubit.dart';
import 'package:call_son/feature/guardian_history/presentation/cubit/history/history_state.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/core_widgets/my_tab_bar_view.dart';
import '../../../../core/models/call_model.dart';
import 'widgets/history_view_body.dart';

class GuardianHistoryView extends StatefulWidget {
  const GuardianHistoryView({super.key});

  @override
  State<GuardianHistoryView> createState() => _GuardianHistoryViewState();
}

class _GuardianHistoryViewState extends State<GuardianHistoryView> {
  CallStatus callStatus = CallStatus.waiting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TranslationKeyManager.history.tr, showPopup: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                      label: TranslationKeyManager.waiting.tr.toUpperCase()),
                  TabBarItem(
                      selected: callStatus == CallStatus.accepted,
                      label: TranslationKeyManager.accepted.tr.toUpperCase()),
                  TabBarItem(
                      selected: callStatus == CallStatus.rejected,
                      label: TranslationKeyManager.rejected.tr.toUpperCase()),
                ],
              ),
              const SizedBox(height: 20,),
              Builder(
                builder: (context)
                {
                  if (callStatus == CallStatus.waiting)
                  {
                    return CallsViewBodyWaiting();
                  }
                  else if (callStatus == CallStatus.accepted)
                  {
                    return CallsViewBodyAccepted();
                  }
                  else
                  {
                    return CallsViewBodyRejected();
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }
}
/*
BlocConsumer<HistoryCubit, HistoryState>(
              listener: (context, state) {},
              builder: (context, state) {
                if(state is HistoryLoading)
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if(state is HistoryError)
                {
                  return Center(
                    child: Text(state.error),
                  );
                }
                else if(state is HistorySuccess)
                {
                  List<CallModel> calls ;
                  if(callStatus==CallStatus.Waiting)
                    calls = state.callData.waitingCalls;
                  else if(callStatus==CallStatus.Accepted)
                    calls = state.callData.acceptedCalls;
                  else
                    calls = state.callData.rejectedCalls;

                  if(calls.isEmpty)
                  {
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                      DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        columns: [
                          DataColumn(
                            label: Center(child: Text('Date & Time')),
                          ),
                          DataColumn(
                            label:  Center(child: Text('Kid')),
                          ),
                          DataColumn(
                            label: Center(child: Text('School')),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          calls.length,
                          (index) => DataRow(
                            cells:
                            [
                              DataCell(Center(child: Text(DateTime.parse(calls[index].dateTime!).toString()))),
                              DataCell(Center(child: Text(calls[index].kidModel!.name!))),
                              DataCell(Center(child: Text(calls[index].schoolModel!.name!))),
                            ]
                          )
                        )
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
 */