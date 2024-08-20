import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';


class ParentSchoolProfileView extends StatelessWidget {
  const ParentSchoolProfileView({super.key, required this.school});

  final SchoolModel school;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TranslationKeyManager.profile.tr, showPopup: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            ParentSchoolProfileImageCard(schoolModel: school,),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: DefaultButton(onTap: (){}, text: TranslationKeyManager.joinRequest.tr),
            )
          ],
        ),
      ),
    );
  }
}

class ParentSchoolProfileImageCard extends StatelessWidget {
  const ParentSchoolProfileImageCard({super.key, required this.schoolModel});

  final SchoolModel schoolModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.4,
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Builder(
                  builder: (context) {
                    if(schoolModel.imagePath != null)
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
                color:  schoolModel.imagePath == null? null:  ColorsManager.black.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:
                    [
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
      ),
    );
  }
}
