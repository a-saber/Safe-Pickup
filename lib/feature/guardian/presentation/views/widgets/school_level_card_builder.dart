import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_levels/get_levels_cubit.dart';
import 'package:call_son/feature/guardian/presentation/views/edit_kid_view.dart';
import 'package:call_son/feature/guardian/presentation/views/parent_school_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';


class SchoolLevelCardBuilder extends StatelessWidget {
  const SchoolLevelCardBuilder(
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
      color: ColorsManager.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
          IconButton(
              onPressed: () {
                GetLevelsCubit.get(context).getLevels(schoolId: school.id!);
                Get.to(
                      () => EditKidSchoolLevel(
                    kid: kid,
                    level: level,
                    school: school,
                  ),
                  duration: const Duration(milliseconds: 500),
                  transition: DelayManager.rightToLeftWithFade,
                );
              },
              icon: const Icon(
                IconlyLight.edit,
                color: ColorsManager.primary,
                size: 20,
              ))
        ],
      ),
    );
  }
}

class SchoolCardBuilder extends StatelessWidget {
  const SchoolCardBuilder(
      {super.key,
        required this.school,});

  final SchoolModel school;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(()=>ParentSchoolProfileView(school: school),
          duration: const Duration(milliseconds: 500),
          transition: DelayManager.rightToLeftWithFade,);
      },
      child: Card(
        color: ColorsManager.secondary,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                              .copyWith(fontSize: 15.0, color: ColorsManager.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              IconlyBold.location,
                              size: 15,
                              color: ColorsManager.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              school.location ?? '',
                              style: StyleManager.bold.copyWith(
                                  color: ColorsManager.white,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

