import 'dart:math';

import 'package:call_son/core/cache_helper/cache_data.dart';
import 'package:call_son/core/cache_helper/cache_helper_keys.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/pop_up/copy_clipboard.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/change_call_status/change_call_status_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/change_call_status/change_call_status_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';


class SchoolCallsViewBodyWaiting extends StatelessWidget {
  const SchoolCallsViewBodyWaiting({super.key,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginateFirestore(
          itemsPerPage: 10,
          initialLoader: CircularProgressIndicator(),
          onEmpty: Text(TranslationKeyManager.noData.tr),
          onError: (e){return Text(TranslationKeyManager.someThingWentWrong.tr);},
        itemBuilder: (context, callSnapshot, index)
        {
          CallModel callModel = CallModel.fromJson(callSnapshot[index].data()as Map<String, dynamic>);
          callModel.schoolModel = GetSchoolCubit.get(context).schoolModel;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
                .doc(callModel.parentId).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> parentSnapshot) {

              if (parentSnapshot.hasError) {
                return Text(TranslationKeyManager.someThingWentWrong.tr);
              }

              if (parentSnapshot.hasData && !parentSnapshot.data!.exists) {
                return Text(TranslationKeyManager.someThingWentWrong.tr);
              }

              if (parentSnapshot.connectionState == ConnectionState.done) {
                callModel.parentModel = ParentModel.fromJson(parentSnapshot.data!.data() as Map<String, dynamic>);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
                      .doc(callModel.kidId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> kidSnapshot) {

                    if (kidSnapshot.hasError) {
                      return Text(TranslationKeyManager.someThingWentWrong.tr);
                    }

                    if (kidSnapshot.hasData && !kidSnapshot.data!.exists) {
                      return Text(TranslationKeyManager.someThingWentWrong.tr);
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
                            return Text(TranslationKeyManager.someThingWentWrong.tr);
                          }

                          if (levelSnapshot.hasData && !levelSnapshot.data!.exists) {
                            return Text(TranslationKeyManager.someThingWentWrong.tr);
                          }

                          if (levelSnapshot.connectionState == ConnectionState.done) {
                            callModel.schoolModel!.kidLevelModel = LevelModel.fromJson(levelSnapshot.data!.data() as Map<String, dynamic>);
                            return SchoolCallCardBuilder(callStatus: CallStatus.waiting, call: callModel);
                          }

                          return SizedBox();
                        },
                      );
                    }

                    return SizedBox();
                  },
                );
              }

              return SizedBox();
            },
          );
        },
          isLive: true,
        query: FirebaseFirestore.instance
            .collection(CollectionManager.callCollection)
            .where('schoolId', isEqualTo: GetSchoolCubit.get(context).schoolModel!.id!)
            .where('status', isEqualTo: 2)
            .orderBy('createdAt', descending: true),
        itemBuilderType: PaginateBuilderType.listView
      ),
    );
  }
}

class SchoolCallsViewBodyAccepted extends StatelessWidget {
  const SchoolCallsViewBodyAccepted({super.key,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginateFirestore(
          itemsPerPage: 10,
          initialLoader: CircularProgressIndicator(),
          onEmpty: Text(TranslationKeyManager.noData.tr),
          onError: (e){return Text(TranslationKeyManager.someThingWentWrong.tr);},
        itemBuilder: (context, callSnapshot, index)
        {
          CallModel callModel = CallModel.fromJson(callSnapshot[index].data()as Map<String, dynamic>);
          callModel.schoolModel = GetSchoolCubit.get(context).schoolModel;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
                .doc(callModel.parentId).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> parentSnapshot) {

              if (parentSnapshot.hasError) {
                return Text(TranslationKeyManager.someThingWentWrong.tr);
              }

              if (parentSnapshot.hasData && !parentSnapshot.data!.exists) {
                return Text(TranslationKeyManager.someThingWentWrong.tr);
              }

              if (parentSnapshot.connectionState == ConnectionState.done) {
                callModel.parentModel = ParentModel.fromJson(parentSnapshot.data!.data() as Map<String, dynamic>);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
                      .doc(callModel.kidId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> kidSnapshot) {

                    if (kidSnapshot.hasError) {
                      return Text(TranslationKeyManager.someThingWentWrong.tr);
                    }

                    if (kidSnapshot.hasData && !kidSnapshot.data!.exists) {
                      return Text(TranslationKeyManager.someThingWentWrong.tr);
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
                            return Text(TranslationKeyManager.someThingWentWrong.tr);
                          }

                          if (levelSnapshot.hasData && !levelSnapshot.data!.exists) {
                            return Text(TranslationKeyManager.someThingWentWrong.tr);
                          }

                          if (levelSnapshot.connectionState == ConnectionState.done) {
                            callModel.schoolModel!.kidLevelModel = LevelModel.fromJson(levelSnapshot.data!.data() as Map<String, dynamic>);
                            return SchoolCallCardBuilder(callStatus: CallStatus.accepted, call: callModel);
                          }

                          return SizedBox();
                        },
                      );
                    }

                    return SizedBox();
                  },
                );
              }

              return SizedBox();;
            },
          );
        },
          isLive: true,
        query: FirebaseFirestore.instance
            .collection(CollectionManager.callCollection)
            .where('schoolId', isEqualTo: GetSchoolCubit.get(context).schoolModel!.id!)
            .where('status', isEqualTo: 1)
            .orderBy('createdAt', descending: true),
        itemBuilderType: PaginateBuilderType.listView
      ),
    );
  }
}

class SchoolCallsViewBodyRejected extends StatelessWidget {
  const SchoolCallsViewBodyRejected({super.key,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginateFirestore(
          itemsPerPage: 10,
          initialLoader: CircularProgressIndicator(),
          onEmpty: Text(TranslationKeyManager.noData.tr),
          onError: (e){return Text(TranslationKeyManager.someThingWentWrong.tr);},
          itemBuilder: (context, callSnapshot, index)
          {
            CallModel callModel = CallModel.fromJson(callSnapshot[index].data()as Map<String, dynamic>);
            callModel.schoolModel = GetSchoolCubit.get(context).schoolModel;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
                  .doc(callModel.parentId).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> parentSnapshot) {

                if (parentSnapshot.hasError) {
                  return Text(TranslationKeyManager.someThingWentWrong.tr);
                }

                if (parentSnapshot.hasData && !parentSnapshot.data!.exists) {
                  return Text(TranslationKeyManager.someThingWentWrong.tr);
                }

                if (parentSnapshot.connectionState == ConnectionState.done) {
                  callModel.parentModel = ParentModel.fromJson(parentSnapshot.data!.data() as Map<String, dynamic>);
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
                        .doc(callModel.kidId).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> kidSnapshot) {

                      if (kidSnapshot.hasError) {
                        return Text(TranslationKeyManager.someThingWentWrong.tr);
                      }

                      if (kidSnapshot.hasData && !kidSnapshot.data!.exists) {
                        return Text(TranslationKeyManager.someThingWentWrong.tr);
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
                              return Text(TranslationKeyManager.someThingWentWrong.tr);
                            }

                            if (levelSnapshot.hasData && !levelSnapshot.data!.exists) {
                              return Text(TranslationKeyManager.someThingWentWrong.tr);
                            }

                            if (levelSnapshot.connectionState == ConnectionState.done) {
                              callModel.schoolModel!.kidLevelModel = LevelModel.fromJson(levelSnapshot.data!.data() as Map<String, dynamic>);
                              return SchoolCallCardBuilder(callStatus: CallStatus.rejected, call: callModel);
                            }

                            return SizedBox();
                          },
                        );
                      }

                      return SizedBox();
                    },
                  );
                }

                return SizedBox();
              },
            );
          },
          isLive: true,
          query: FirebaseFirestore.instance
              .collection(CollectionManager.callCollection)
              .where('schoolId', isEqualTo: GetSchoolCubit.get(context).schoolModel!.id!)
              .where('status', isEqualTo: 0)
              .orderBy('createdAt', descending: true),
          itemBuilderType: PaginateBuilderType.listView
      ),
    );
  }
}


/*class SchoolCallsViewBody extends StatelessWidget {
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
          return Center(child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(TranslationKeyManager.noData.tr),
          ),);
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
                    return Text(TranslationKeyManager.someThingWentWrong.tr);
                  }

                  if (parentSnapshot.hasData && !parentSnapshot.data!.exists) {
                    return Text(TranslationKeyManager.someThingWentWrong.tr);
                  }

                  if (parentSnapshot.connectionState == ConnectionState.done) {
                    callModel.parentModel = ParentModel.fromJson(parentSnapshot.data!.data() as Map<String, dynamic>);
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
                          .doc(callModel.kidId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> kidSnapshot) {

                        if (kidSnapshot.hasError) {
                          return Text(TranslationKeyManager.someThingWentWrong.tr);
                        }

                        if (kidSnapshot.hasData && !kidSnapshot.data!.exists) {
                          return Text(TranslationKeyManager.someThingWentWrong.tr);
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
                                return Text(TranslationKeyManager.someThingWentWrong.tr);
                              }

                              if (levelSnapshot.hasData && !levelSnapshot.data!.exists) {
                                return Text(TranslationKeyManager.someThingWentWrong.tr);
                              }

                              if (levelSnapshot.connectionState == ConnectionState.done) {
                                callModel.schoolModel!.kidLevelModel = LevelModel.fromJson(levelSnapshot.data!.data() as Map<String, dynamic>);
                                return SchoolCallCardBuilder(callStatus: callStatus, call: callModel);
                              }

                              return Text(TranslationKeyManager.loading.tr);
                            },
                          );
                        }

                        return Text(TranslationKeyManager.loading.tr);
                      },
                    );
                  }

                  return Text(TranslationKeyManager.loading.tr);
                },
              );
            }),
        );


      },
    );
  }
}*/
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
                        Builder(
                          builder: (context) {
                            late double angle ;
                            if(CacheData.lang == CacheHelperKeys.keyEN)
                            {
                              angle = 0;
                            }
                            else
                            {
                              angle = pi*-0.5;
                            }
                            return Transform.rotate(
                              angle: angle,
                              child: const Icon(IconlyLight.call, size: 15,color: ColorsManager.grey,));
                          }
                        ),
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
                      call.createdAt!.toDate().toString().substring(0, 16),
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
                        late IconData icon;
                        if(callStatus == CallStatus.accepted)
                        {
                          color = ColorsManager.primary;
                          icon = Icons.check_circle_outline;
                        }
                        else
                        {
                          icon = Icons.cancel_outlined;
                          color = ColorsManager.secondary;
                        }
                        return Row(
                          children: [
                            Icon(
                              icon,
                              size: 15,
                              color: color,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              call.editedAt!.toDate().toString().substring(0, 16),
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
                                text: TranslationKeyManager.accept.tr,
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
                          text: TranslationKeyManager.reject.tr,
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
                  TranslationKeyManager.explainParentWhyReject.tr,
                  textAlign: TextAlign.center,
                  style: StyleManager.regular.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                    labelText: TranslationKeyManager.reason.tr,
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
                            child: Text(TranslationKeyManager.cancel.tr,
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
                                  child: Text(TranslationKeyManager.reject.tr,
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
