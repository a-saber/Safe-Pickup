import 'package:call_son/core/core_widgets/default_form/default_form_field2.dart';
import 'package:call_son/core/core_widgets/more/default_add_row.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/guardian_register_ui/guardian_register_ui_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/guardian_register_ui/guardian_register_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';


import 'school_bottom_sheet.dart';

class ParentKidsData extends StatelessWidget {
  const ParentKidsData({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentRegisterUiCubit, ParentRegisterUiState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ParentRegisterUiCubit.get(context);
        return Column(
          children:
          [
            DefaultAddRow(
                text: TranslationKeyManager.kidsA.tr,
                number: cubit.kids.length,
                icon: IconlyLight.add_user,
                onPressed: ParentRegisterUiCubit.get(context).addNewChild
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsetsDirectional.only(start: 10, top: 15),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          DefaultFormField2(
                            hintText: TranslationKeyManager.kidName.tr,
                            textInputType: TextInputType.name,
                            controller: cubit.kids[index].nameController,
                          ),
                          const SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: DefaultAddRow(
                              isInner: true,
                              number: cubit.kids[index].schools.length,
                                text: TranslationKeyManager.schools.tr,
                                onPressed: (){cubit.addSchool(kidIndex: index);}
                            ),
                          ),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, schoolIndex)
                              {
                                return Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children:
                                  [
                                    Expanded(
                                      child: InkWell(
                                        onTap:()
                                        {
                                          showBottomSheet(
                                              context:context,
                                              backgroundColor: Colors.transparent,builder:  (context) {
                                            return SchoolsBottomSheetBody(
                                              isSearch: false,
                                              search: TextEditingController(),
                                              onTap: (schoolModel)
                                              {
                                                cubit.chooseSchool(kidIndex: index, schoolIndex: schoolIndex, schoolModel: schoolModel);
                                                Navigator.pop(context);
                                              },
                                            );
                                          });
                                        },
                                        child: DefaultFormField2(
                                          hintText: TranslationKeyManager.school.tr,
                                            enabled: false,
                                            controller: TextEditingController(
                                                text: cubit.kids[index].schools[schoolIndex].name ?? ''
                                            )
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                        child: InkWell(
                                          onTap: ()
                                          {
                                            if(cubit.kids[index].schools[schoolIndex].id==null)
                                            {
                                              callMySnackBar(backgroundColor: ColorsManager.red,context: context, text: TranslationKeyManager.plzChooseSchool.tr);
                                            }
                                            else
                                            {
                                              showBottomSheet(
                                                  context:context,
                                                  backgroundColor: Colors.transparent,builder:  (context) {
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
                                                        color: Colors.black.withOpacity(0.5),
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
                                                                    '${cubit.kids[index].schools[schoolIndex].name ?? ''} ${TranslationKeyManager.levels.tr}',
                                                                    style: const TextStyle(
                                                                        color: Colors.grey,
                                                                        fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Expanded(
                                                                  child: ListView.builder(
                                                                      itemCount: cubit.kids[index].schools[schoolIndex].levels.length,
                                                                      itemBuilder: (context, levelIndex) => Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal: 30.0, vertical: 7),
                                                                        child: InkWell(
                                                                          onTap: ()
                                                                          {
                                                                            cubit.chooseLevel(kidIndex: index, schoolIndex: schoolIndex, levelIndex: levelIndex);
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
                                                                                      cubit.kids[index].schools[schoolIndex].levels[levelIndex].name!,
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
                                            }
                                          },
                                          child: DefaultFormField2(
                                            hintText: TranslationKeyManager.level.tr,
                                              enabled: false,
                                              controller: TextEditingController(
                                                  text: cubit.kids[index].schools[schoolIndex].kidLevelModel!=null ?
                                                  cubit.kids[index].schools[schoolIndex].kidLevelModel!.name :
                                                  ''
                                              )
                                          ),
                                        ),
                                      ),
                                    if(cubit.kids[index].schools.length >1)
                                    IconButton(
                                      onPressed: ()
                                      {
                                        cubit.removeSchool(kidIndex: index, schoolIndex: schoolIndex);
                                      },
                                      icon: const Icon(
                                        IconlyLight.delete,
                                        color:ColorsManager.primary,
                                      )
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, schoolIndex)=>const SizedBox(height: 10,),
                              itemCount: cubit.kids[index].schools.length
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(cubit.canRemove())
                  CircleAvatar(
                    backgroundColor: ColorsManager.red,
                    radius: 15,
                    child: Center(
                      child: IconButton(
                          onPressed: (){cubit.removeChild(index);},
                          icon: const Center(child: Icon(IconlyLight.delete, color: ColorsManager.white,size: 15,))),
                    ),
                  )
                ],
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10,),
              itemCount: cubit.kids.length,
            ),
          ],
        );
      },
    );
  }
}
