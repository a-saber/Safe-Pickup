import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';


class HistoryViewBody extends StatelessWidget {
  const HistoryViewBody({super.key, required this.callStatus,});
  final CallStatus callStatus;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance
          .collection(CollectionManager.callCollection)
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('status',
          isEqualTo: callStatus==CallStatus.waiting ?2 :
          callStatus==CallStatus.accepted?1:0)
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
          return Center(child: Text(TranslationKeyManager.noData.tr),);
        }
        print(callSnapshot.data!.docs.length);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: callSnapshot.data!.docs.length,
              itemBuilder: (context, index)
              {
                CallModel callModel = CallModel.fromJson(callSnapshot.data!.docs[index].data()as Map<String, dynamic>);
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
                            .doc(callModel.schoolId).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> schoolSnapshot) {

                          if (schoolSnapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (schoolSnapshot.hasData && !schoolSnapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (schoolSnapshot.connectionState == ConnectionState.done) {
                            callModel.schoolModel = SchoolModel.fromJson(schoolSnapshot.data!.data() as Map<String, dynamic>);
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
                                  .doc(callModel.schoolId).collection(CollectionManager.levelsCollection)
                                  .doc(callModel.levelId).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData && !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  callModel.schoolModel!.kidLevelModel = LevelModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                  return CallCardBuilder(callStatus: callStatus, call: callModel);
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
              })
            ,
          ),
        );

      },
    );
  }
}

class CallCardBuilder extends StatelessWidget {
  const CallCardBuilder({super.key, required this.callStatus, required this.call});

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
            Row(
              children: [
                Builder(builder: (context) {
                  if (call.schoolModel!.imagePath == null) {
                    return const IconImageViewer();
                  } else {
                    return CloudImageViewer(imagePath: call.schoolModel!.imagePath!);
                  }
                }),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${call.schoolModel!.name} School',
                        style: StyleManager.semiBold
                            .copyWith(fontSize: 15.0),
                      ),
                      Row(
                        children: [
                          Text(
                            call.kidModel!.name ?? '',
                            style: StyleManager.medium
                                .copyWith(fontSize: 12.0, height: 1.2),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            call.schoolModel!.kidLevelModel!.name ?? '',
                            style: StyleManager.medium
                                .copyWith(fontSize: 12.0, height: 1.2),
                          ),
                        ],
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

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


