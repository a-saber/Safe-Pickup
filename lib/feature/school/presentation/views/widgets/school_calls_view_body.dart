import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field2.dart';
import 'package:call_son/core/core_widgets/pop_up/copy_clipboard.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/change_call_status/change_call_status_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/change_call_status/change_call_status_state.dart';
import 'package:call_son/feature/school/presentation/cubit/get_calls/get_calls_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';


class SchoolCallsViewBody extends StatelessWidget {
  const SchoolCallsViewBody({super.key, required this.callStatus,});
  final CallStatus callStatus;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> stream=FirebaseFirestore.instance
        .collection(CollectionManager.callCollection)
        .where('schoolId', isEqualTo: GetSchoolCubit.get(context).schoolModel!.id!)
        .where('status', isEqualTo:
        callStatus == CallStatus.waiting ?
        2:
        callStatus == CallStatus.accepted ?
        1 : 0)
        .orderBy('createdAt', descending: true).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> callSnapshot)
      {
        if (callSnapshot.hasError) {
          return Text(callSnapshot.error.toString());
        }
        if (callSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if(callSnapshot.data!.docs.isEmpty)
        {
          return const Center(child: Text('No Data'),);
        }
        return Expanded(
          child: ListView.builder(
            padding:  const EdgeInsets.only(top: 10),
            itemCount: callSnapshot.data!.docs.length,
            itemBuilder: (context, index)
            {
              CallModel callModel = CallModel.fromJson(callSnapshot.data!.docs[index].data()as Map<String, dynamic>);
              callModel.schoolModel = GetSchoolCubit.get(context).schoolModel;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
                    .doc(callModel.parentId).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> parentSnapshot) {
          
                  if (parentSnapshot.hasError) {
                    return Text("Something went wrong");
                  }
          
                  if (parentSnapshot.hasData && !parentSnapshot.data!.exists) {
                    return Text("Document does not exist");
                  }
          
                  if (parentSnapshot.connectionState == ConnectionState.done) {
                    callModel.parentModel = ParentModel.fromJson(parentSnapshot.data!.data() as Map<String, dynamic>);
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
                          .doc(callModel.kidId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> kidSnapshot) {
          
                        if (kidSnapshot.hasError) {
                          return Text("Something went wrong");
                        }
          
                        if (kidSnapshot.hasData && !kidSnapshot.data!.exists) {
                          return Text("Document does not exist");
                        }
          
                        if (kidSnapshot.connectionState == ConnectionState.done) {
                          callModel.kidModel = KidModel.fromJson(kidSnapshot.data!.data() as Map<String, dynamic>);
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
                                .doc(callModel.schoolId).collection(CollectionManager.levelsCollection)
                                .doc(callModel.levelId).get(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> levelSnapshot) {
                              print(callModel.levelId);
                              if (levelSnapshot.hasError) {
                                return Text("Something went wrong");
                              }
          
                              if (levelSnapshot.hasData && !levelSnapshot.data!.exists) {
                                return Text("Document does not exist");
                              }
          
                              if (levelSnapshot.connectionState == ConnectionState.done) {
                                callModel.schoolModel!.kidLevelModel = LevelModel.fromJson(levelSnapshot.data!.data() as Map<String, dynamic>);
                                return SchoolCallCardBuilder(callStatus: callStatus, call: callModel);
                              }
          
                              return Text("loading");
                            },
                          );
                        }
          
                        return Text("loading");
                      },
                    );
                  }
          
                  return Text("loading");
                },
              );
            }),
        );
        

      },
    );
  }
}

class SchoolCallCardBuilder extends StatelessWidget {
  const SchoolCallCardBuilder({super.key, required this.callStatus, required this.call});

  final CallStatus callStatus;
  final CallModel call;
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: ColorsManager.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${call.kidModel!.name} ${call.parentModel!.name }',
                  style: StyleManager.semiBold
                      .copyWith(fontSize: 15.0),
                ),
                const SizedBox(height: 3.5,),
                Text(
                  call.schoolModel!.kidLevelModel!.name ?? '',
                  style: StyleManager.medium
                      .copyWith(fontSize: 15.0),
                ),
                const SizedBox(height: 3.5,),
                InkWell(
                    onTap: ()
                    {
                      copyToClipBoard(context: context, text: call.parentModel!.phone! );
                    },
                    child: Row(
                      children:
                      [
                        Icon(IconlyLight.call, size: 15,color: ColorsManager.grey,),
                        const SizedBox(width: 5,),
                        Text(
                            call.parentModel!.phone!,
                          style: StyleManager.semiBold.copyWith(
                              color: ColorsManager.grey,
                              fontSize: 12.0
                          ),
                        ),
                      ],
                    )
                ),

                const SizedBox(height: 3.5,),
                Row(
                  children: [
                    const Icon(
                      IconlyLight.time_circle,
                      size: 15,
                      color: ColorsManager.grey,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      call.createdAt!.toDate().toString().substring(0, 16) ?? '',
                      style: StyleManager.semiBold.copyWith(
                          color: ColorsManager.grey,
                          fontSize: 12.0),
                    ),
                  ],
                ),
                const SizedBox(height: 3.5,),
                if(callStatus != CallStatus.waiting )
                  Builder(
                      builder: (context) {
                        late Color color;
                        if(callStatus == CallStatus.accepted)
                        {
                          color = ColorsManager.primary;
                        }
                        else
                        {
                          color = ColorsManager.secondary;
                        }
                        return Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 15,
                              color: color,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              call.editedAt!.toDate().toString().substring(0, 16) ?? '',
                              style: StyleManager.semiBold.copyWith(
                                  color: color,
                                  fontSize: 12.0),
                            ),
                          ],
                        );
                      }
                  ),
                const SizedBox(height: 3.5,),
                if(callStatus == CallStatus.rejected )
                  Text(
                    call.rejectReason ?? '',
                    style: StyleManager.medium
                        .copyWith(fontSize: 12.0, height: 1.2),
                  ),

                if(callStatus == CallStatus.waiting )
                  Row(
                    children:
                    [
                      BlocConsumer<ChangeCallStatusCubit, ChangeCallStatusState>(
                        listener: (context, state) {
                          if (state is ChangeCallStatusError)
                          {
                            callMySnackBar(context: context, text: state.error);
                          }
                          if(state is ChangeCallStatusSuccess)
                          {
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, state) {
                          if(state is ChangeCallStatusLoading)
                          {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          else
                          {
                            return Expanded(
                              child: DefaultButton(
                                text: 'Accept',
                                  onTap: ()
                                  {
                                    ChangeCallStatusCubit.get(context).changeCallStatus(
                                      callId: call.id!,
                                      accepted: true,
                                    );
                                  }),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: DefaultButton(
                          buttonColor:  ColorsManager.secondary,
                          onTap: ()
                          {
                            showDialog(
                                context: context,
                                builder: (context) => alertReject(context, call: call)
                            );
                          },
                          text: 'Reject',
                        ),
                      ),
                    ],
                  ),
                        
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Widget alertReject(context, {required CallModel call})
{
  final formKey = GlobalKey<FormState>();
  final reply = TextEditingController();
  return AlertDialog(
    insetPadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0))),
    content: Form(
      key: formKey,
      child: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorsManager.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: width * 0.35,
            height: height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Explain to the guardian, why you reject the call !',
                  textAlign: TextAlign.center,
                  style: StyleManager.regular.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                    labelText: 'Reason',
                    controller: reply),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                          color: ColorsManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('Cancel',
                                style: StyleManager.regular.copyWith(
                                  color: Colors.white,
                                  fontSize: 19,
                                )),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    BlocConsumer<ChangeCallStatusCubit, ChangeCallStatusState>(
                      listener: (context, state) {
                        if (state is ChangeCallStatusError)
                        {
                          callMySnackBar(context: context, text: state.error);
                        }
                        if(state is ChangeCallStatusSuccess)
                        {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if(state is ChangeCallStatusLoading)
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        else
                        {
                          return Expanded(
                            child: MaterialButton(
                                color: ColorsManager.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                      color: ColorsManager.primary, width: 2),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  child: Text('Reject',
                                      style: StyleManager.regular.copyWith(
                                        color: ColorsManager.primary,
                                        fontSize: 19,
                                      )),
                                ),
                                onPressed: ()
                                {
                                  if (formKey.currentState!.validate())
                                  {
                                    ChangeCallStatusCubit.get(context).changeCallStatus(
                                      callId: call.id!,
                                      accepted: false,
                                      reply: reply.text,
                                    );
                                  }
                                }),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
