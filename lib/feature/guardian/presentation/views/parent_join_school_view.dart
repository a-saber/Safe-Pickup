
import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field2.dart';
import 'package:call_son/core/core_widgets/defualt_drop_down/default_drop_down.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/guardian/presentation/cubit/add_kid_level/add_kid_level_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/add_kid_level/add_kid_level_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_levels/get_levels_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_levels/get_levels_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ParentJoinSchoolView extends StatefulWidget {
  const ParentJoinSchoolView({super.key, required this.school});
  final SchoolModel school;


  @override
  State<ParentJoinSchoolView> createState() => _ParentJoinSchoolViewState();
}

class _ParentJoinSchoolViewState extends State<ParentJoinSchoolView> {
  var formKey = GlobalKey<FormState>();
  KidModel? kid;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: TranslationKeyManager.joinRequest.tr, showPopup: true,),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children:
            [
              InkWell(
                  onTap: ()
                  {
                    scaffoldKey.currentState!
                        .showBottomSheet((context) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.transparent,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.65,
                            decoration: BoxDecoration(
                              //color: Colors.white,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                )),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        width: double.infinity,
                                        color: Colors.grey.withOpacity(0.2),
                                        child: Text(
                                          widget.school.name ?? '',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      BlocBuilder<GetLevelsCubit, GetLevelsState>(
                                        builder: (context, state) {
                                          if(state is GetLevelsLoading)
                                          {
                                            return const Center(child: CircularProgressIndicator(),);
                                          }
                                          else if(state is GetLevelsFailure)
                                          {
                                            return Center(child: Text(state.failure.errorMessage),);
                                          }
                                          else if (state is GetLevelsSuccess)
                                          {
                                            return Expanded(
                                              child: ListView.builder(
                                                  itemCount: GetLevelsCubit.get(context).levels.length,
                                                  itemBuilder: (context, levelIndex) => Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 30.0, vertical: 7),
                                                    child: InkWell(
                                                      onTap: ()
                                                      {
                                                        setState(() {
                                                          widget.school.kidLevelModel = GetLevelsCubit.get(context).levels[levelIndex];
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              const Icon(
                                                                  Icons.school,
                                                                  size: 20,
                                                                  color: ColorsManager.primary
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  GetLevelsCubit.get(context).levels[levelIndex].name!,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider()
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          }
                                          else
                                          {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    });
                  },
                  child:
                  TextFormField(
                    controller: TextEditingController(
                        text: widget.school.kidLevelModel ==null? '': widget.school.kidLevelModel!.name
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return  TranslationKeyManager.notEmpty.tr;
                      }
                      return null;
                    },
                    enabled: false,
                    style: StyleManager.semiBold.copyWith(
                      fontSize: 18.0,
                      color: ColorsManager.black
                    ),
                    decoration: InputDecoration(
                        labelText: TranslationKeyManager.level.tr,
                        labelStyle: StyleManager.semiBold.copyWith(
                          fontSize: 18.0,
                        ),
                        errorStyle: StyleManager.regular.copyWith(color: ColorsManager.red),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ColorsManager.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsetsDirectional.only(start: 10.0)
                    ),
                  )
                ),
              const SizedBox(
                height: 20,
              ),

              BlocConsumer<GetAllParentKidsCubit, GetAllParentKidsState>(
                listener: (context, state) {},
                builder: (context, state)
                {
                  if (state is GetAllParentKidsSuccess)
                  {
                    return KidsDropDown(
                        text: TranslationKeyManager.kid.tr,
                        textEditingController: TextEditingController(text: kid != null? kid!.name: ''),
                        kids: GetAllParentKidsCubit.get(context).kids,
                        value: kid,
                        onChanged: (KidModel? kid)
                        {
                          this.kid = kid;
                          setState(() {});
                        }
                    );
                  }
                  else if(state is GetAllParentKidsLoading)
                  {
                    return  const Center(child: CircularProgressIndicator());
                  }
                  else if(state is GetAllParentKidsError)
                  {
                    return Text(state.error);
                  }
                  else
                  {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),

              if(widget.school.kidLevelModel != null)
                if(kid != null)
                  BlocConsumer<AddKidLevelCubit, AddKidLevelState>(
                    listener: (context, state) {
                      if (state is AddKidLevelFailure) {
                        callMySnackBar(
                            context: context, text: state.failure.errorMessage);
                      } else if (state is AddKidLevelSuccess) {
                        GetKidDataCubit.get(context).getKidData(kidId: kid!.id!);
                        callMySnackBar(context: context, text: TranslationKeyManager.addSuccessfully.tr);
                      }
                    },
                    builder: (context, state) {
                      if (state is AddKidLevelLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return DefaultButton(
                          onTap: () {
                            if (formKey.currentState!.validate())
                            {
                              AddKidLevelCubit.get(context)
                                  .addKidLevel(
                                  kidId: kid!.id!,
                                  schoolId: widget.school.id!,
                                  levelId: widget.school.kidLevelModel!.id!
                              );
                            }
                          },
                          text: TranslationKeyManager.add.tr
                      );
                    },
                  ),

            ],
          ),
        ),
      ),
    );
  }
}
