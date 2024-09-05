import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class ResultView extends StatelessWidget {
  const ResultView({super.key, required this.kid, required this.school, required this.callId});
  final KidModel kid;
  final SchoolModel school;
  final String callId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TranslationKeyManager.waitForResponse.tr, showPopup: true,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<DocumentSnapshot> (
          stream: FirebaseFirestore.instance
              .collection(CollectionManager.callCollection)
              .doc(callId).snapshots(),
          builder: (context, snapshot)
          {
            if(snapshot.data != null)
            {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [

                  ResponseSchoolLevelCardBuilder(
                      school: school,
                      level: school.kidLevelModel!,
                      kid: kid
                  ),
                  const SizedBox(height: 15,),
                  Builder(
                    builder: (context)
                    {
                      if(snapshot.data!['status']==2)
                      {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color:  ColorsManager.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:
                              [
                                const Icon(IconlyLight.calling,),
                                const SizedBox(width: 15,),
                                Expanded(
                                  child: Text('${TranslationKeyManager.waitingForSchResForUKidReq.tr} ${kid.name}',
                                    style: StyleManager.regular.copyWith(
                                        fontSize: 17,
                                    ),),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else if(snapshot.data!['status']==1)
                      {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color:  ColorsManager.primary,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:
                              [
                                const Icon(Icons.check_circle_outline, color: ColorsManager.white,),
                                const SizedBox(width: 15,),
                                Expanded(
                                  child: Text('${TranslationKeyManager.schoolAcceptedUKidReq.tr} ${kid.name}',
                                    style: StyleManager.regular.copyWith(
                                        fontSize: 17,
                                      color: ColorsManager.white
                                    ),),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else
                      {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color:  ColorsManager.secondary,
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children:
                                  [
                                    const Icon(IconlyLight.call_silent, color:  ColorsManager.white,),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${TranslationKeyManager.schoolRejectedUKidReq.tr} ${kid.name}',
                                            style: StyleManager.regular.copyWith(
                                              fontSize: 17,
                                              color: ColorsManager.white
                                            ),),
                                          const SizedBox(height: 10,),
                                          Text('${TranslationKeyManager.schoolReply.tr} ${snapshot.data!['rejectReason']}',
                                              style: StyleManager.regular.copyWith(
                                                  fontSize: 17,
                                                  color: ColorsManager.white
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        );
                      }
                    }),
                ],
              );
            }
            else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class ResponseSchoolLevelCardBuilder extends StatelessWidget {
  const ResponseSchoolLevelCardBuilder(
      {super.key,
        required this.school,
        required this.level,
        required this.kid,});

  final SchoolModel school;
  final LevelModel level;
  final KidModel kid;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
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
                  if (school.imagePath == null) {
                    return const IconImageViewer();
                  } else {
                    return CloudImageViewer(imagePath: school.imagePath!);
                  }
                }),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${school.name}',
                        style: StyleManager.semiBold
                            .copyWith(fontSize: 15.0),
                      ),
                      Row(
                        children: [
                          const Icon(
                            IconlyBold.location,
                            size: 15,
                            color: ColorsManager.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            school.location ?? '',
                            style: StyleManager.black.copyWith(
                                color: ColorsManager.grey,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                      Text(
                        level.name ?? '',
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

