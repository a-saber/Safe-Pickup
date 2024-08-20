import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field2.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/feature/guardian/presentation/cubit/add_kid_level/add_kid_level_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/add_kid_level/add_kid_level_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_all_schools/get_all_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_all_schools/get_all_schools_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_levels/get_levels_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_levels/get_levels_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/parent_edit_kid_level/parent_edit_kid_level_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/parent_edit_kid_level/parent_edit_kid_level_state.dart';
import 'package:call_son/feature/guardian/presentation/views/widgets/delete_kid_school_level_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';


class EditKidSchoolLevel extends StatefulWidget {
  const EditKidSchoolLevel({super.key, required this.kid, required this.school, required this.level});

  final SchoolModel school;
  final LevelModel level;
  final KidModel kid;

  @override
  State<EditKidSchoolLevel> createState() => _EditKidSchoolLevelState();
}

class _EditKidSchoolLevelState extends State<EditKidSchoolLevel> {
  var formKey = GlobalKey<FormState>();
  LevelModel? newLevel;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: TranslationKeyManager.editSchoolLevel.tr,
        showPopup: true,
      actions:
      [
        IconButton(onPressed: ()
        {
          showDialog(
              context: context,
              builder: (BuildContext ctx) => alertDeleteKidSchoolLevel(context,
              kidId: widget.kid.id!,
                levelId: widget.level.id!,
                schoolId: widget.school.id!,
              ),
              barrierDismissible: false);
        },
            icon: const Icon(IconlyLight.delete,
              size: 20,
              color: ColorsManager.red,))
      ],),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children:
            [
              DefaultFormField2(
                  hintText: TranslationKeyManager.school.tr,
                  enabled: false,
                  controller: TextEditingController(
                      text: widget.school.name
                  )
              ),
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
                                        '${widget.school.name ?? ''} Levels',
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
                                                        newLevel = GetLevelsCubit.get(context).levels[levelIndex];
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
                                                            Icon(
                                                                Icons.school,
                                                                size: 20,
                                                                color: ColorsManager.primary
                                                            ),
                                                            SizedBox(
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
                child: DefaultFormField2(
                    hintText: TranslationKeyManager.level.tr,
                    enabled: false,
                    controller: TextEditingController(
                      text: newLevel ==null? widget.level.name: newLevel!.name
                    )
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              BlocConsumer<ParentEditKidLevelCubit, ParentEditKidLevelState>(
                listener: (context, state) {
                  if (state is ParentEditKidLevelFailure) {
                    callMySnackBar(
                        context: context, text: state.failure.errorMessage);
                  } else if (state is ParentEditKidLevelSuccess) {
                    GetKidDataCubit.get(context).getKidData(kidId: widget.kid.id!);
                    callMySnackBar(context: context, text: TranslationKeyManager.editedSuccessfully.tr);
                  }
                },
                builder: (context, state) {
                  if (state is ParentEditKidLevelLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return DefaultButton(
                      onTap: () {
                        if (formKey.currentState!.validate())
                        {
                          if(newLevel == null)
                          {
                            callMySnackBar(context: context, text: TranslationKeyManager.pleaseSelectNewLevel.tr);
                          }
                          else {
                            ParentEditKidLevelCubit.get(context)
                                .editKidLevelCubit(
                                kidId: widget.kid.id!,
                                schoolId: widget.school.id!,
                                oldLevelId: widget.level.id!,
                                newLevelId: newLevel!.id!
                            );
                          }
                        }
                      },
                      text: TranslationKeyManager.edit.tr);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}



class NewKidSchool extends StatefulWidget {
  const NewKidSchool({super.key, required this.kid});
  final KidModel kid;


  @override
  State<NewKidSchool> createState() => _NewKidSchoolState();
}

class _NewKidSchoolState extends State<NewKidSchool> {
  var formKey = GlobalKey<FormState>();
  SchoolModel? school;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: TranslationKeyManager.newSchoolLevel.tr, showPopup: true,),
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
                                      child: const Text(
                                        'Schools',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    BlocBuilder<GetAllSchoolsCubit, GetAllSchoolsState>(
                                      builder: (context, state) {
                                        if(state is GetAllSchoolsLoading)
                                        {
                                          return const Center(child: CircularProgressIndicator(),);
                                        }
                                        else if(state is GetAllSchoolsFailure)
                                        {
                                          return Center(child: Text(state.failure.errorMessage),);
                                        }
                                        else if (state is GetAllSchoolsSuccess)
                                        {
                                          return Expanded(
                                            child: ListView.builder(
                                                itemCount: GetAllSchoolsCubit.get(context).schools.length,
                                                itemBuilder: (context, index) => Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 30.0, vertical: 7),
                                                  child: InkWell(
                                                    onTap: ()
                                                    {
                                                      setState(() {
                                                        school = GetAllSchoolsCubit.get(context).schools[index];
                                                        GetLevelsCubit.get(context).getLevels(schoolId: school!.id!);
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
                                                            Icon(
                                                                Icons.school,
                                                                size: 20,
                                                                color: ColorsManager.primary
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                GetAllSchoolsCubit.get(context).schools[index].name!,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider()
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
                child: DefaultFormField2(
                    hintText: 'School',
                    enabled: false,
                    controller: TextEditingController(
                        text: school != null ? school!.name: ''
                    )
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if(school != null)
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
                                        '${school!.name ?? ''} Levels',
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
                                                        school!.kidLevelModel = GetLevelsCubit.get(context).levels[levelIndex];
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
                                                            Icon(
                                                                Icons.school,
                                                                size: 20,
                                                                color: ColorsManager.primary
                                                            ),
                                                            SizedBox(
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
                child: DefaultFormField2(
                    hintText: 'Level',
                    enabled: false,
                    controller: TextEditingController(
                        text: school!.kidLevelModel ==null? '': school!.kidLevelModel!.name
                    )
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              if(school != null)
                if(school!.kidLevelModel != null)
              BlocConsumer<AddKidLevelCubit, AddKidLevelState>(
                listener: (context, state) {
                  if (state is AddKidLevelFailure) {
                    callMySnackBar(
                        context: context, text: state.failure.errorMessage);
                  } else if (state is AddKidLevelSuccess) {
                    GetKidDataCubit.get(context).getKidData(kidId: widget.kid.id!);
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
                              kidId: widget.kid.id!,
                              schoolId: school!.id!,
                              levelId: school!.kidLevelModel!.id!
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
