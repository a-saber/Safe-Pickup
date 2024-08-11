import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_cubit.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_state.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_state.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'school_profile_update_view.dart';

class SchoolProfileView extends StatelessWidget {
  const SchoolProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Profile", showPopup: true,),
      body: BlocBuilder<GetSchoolCubit, GetSchoolState>(
        builder: (context, state) {
          var cubit = GetSchoolCubit.get(context);
          if(cubit.schoolModel == null)
          {
            Get.off(()=> const LoginView());
            return const SizedBox();
          }
          else
          {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children:
                [
                  SchoolProfileImageCard(schoolModel: cubit.schoolModel!,),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class SchoolProfileImageCard extends StatelessWidget {
  const SchoolProfileImageCard({super.key, required this.schoolModel});

  final SchoolModel schoolModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.4,
      child: BlocConsumer<GetImageCubit, GetImageState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = GetImageCubit.get(context);
            return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Builder(
                        builder: (context) {
                          if(cubit.image != null )
                          {
                            return Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height*0.4,
                                decoration:
                                BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: FileImage(File(cubit.image!.path)),
                                      fit: BoxFit.cover,
                                    )
                                )
                            );
                          }
                          else if(schoolModel.imagePath != null)
                          {
                            return CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                              imageUrl: schoolModel.imagePath!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.4,
                            );
                          }
                          else
                          {
                            return Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height*0.4,
                                  color: ColorsManager.black,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height*0.4,
                                  decoration:
                                  BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(70),
                                      child: Image.asset(
                                        AssetsManager.school,
                                        color: ColorsManager.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                        }
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.4,
                      color: cubit.image == null && schoolModel.imagePath == null? null:  ColorsManager.black.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children:
                          [
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  Get.to(()=> SchoolProfileUpdateView(schoolModel: schoolModel,));
                                },
                                child: CircleAvatar(
                                  backgroundColor: ColorsManager.white.withOpacity(0.3),
                                  radius: 16,
                                  child: const Icon(
                                    IconlyLight.edit,
                                    color: ColorsManager.white,
                                    size: 20,),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text('${schoolModel.name} School',
                              textAlign: TextAlign.center,
                              style: StyleManager.bold.copyWith(
                                  color: ColorsManager.white,
                                  fontSize: 20
                              ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(IconlyLight.location,
                                  color: ColorsManager.white, size: 15,),
                                const SizedBox(width: 5,),
                                Text(schoolModel.location??'',
                                  textAlign: TextAlign.center,
                                  style: StyleManager.regular.copyWith(
                                      color: ColorsManager.white,
                                      fontSize: 15
                                  ),),
                              ],
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                )
            );
          }),
    );
  }
}
