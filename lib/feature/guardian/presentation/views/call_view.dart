import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/defualt_drop_down/default_drop_down.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/shared_functions/location.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_state.dart';
import 'package:call_son/feature/guardian/presentation/views/result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/models/school_model.dart';
import '../cubit/call/call_cubit.dart';

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}
class _CallViewState extends State<CallView> {
  @override
  void initState() {
    LocationManager.getPermission(context: context);
    super.initState();
  }

  KidModel? kid;
  SchoolModel? school;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: TranslationKeyManager.pickup.tr,
        showPopup: true,
      ),
      body: BlocConsumer<GetAllParentKidsCubit, GetAllParentKidsState>(
        listener: (context, state) {},
        builder: (context, state)
        {
          if (state is GetAllParentKidsSuccess)
          {

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children:
                  [
                    Column(
                      children:
                      [
                        KidsDropDown(
                            text: TranslationKeyManager.kid.tr,
                            textEditingController: TextEditingController(text: kid != null? kid!.name: ''),
                            kids: GetAllParentKidsCubit.get(context).kids,
                            value: kid,
                            onChanged: (KidModel? kid)
                            {
                              GetKidDataCubit.get(context).getKidData(kidId: kid!.id!); // get kid data
                              this.kid = kid;
                              school = null;
                              setState(() {});
                            }
                        ),
                        const SizedBox(height: 20,),
                        if(kid !=null)
                          BlocConsumer<GetKidDataCubit, GetKidDataState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                             if(state is GetKidDataLoading)
                             {
                               return const Center(child: CircularProgressIndicator());
                             }
                             else if(state is GetKidDataSuccess)
                             {
                               return SchoolsDropDown(
                                   value: school,
                                   text: TranslationKeyManager.kidSchool.tr,
                                   textEditingController: TextEditingController(text: school != null? '${school!.name} ${school!.kidLevelModel!.name}': ''),
                                   schools: GetKidDataCubit.get(context).schools,
                                   onChanged: (SchoolModel? schoolModel)
                                   {
                                     school = schoolModel;
                                     setState(() {});
                                   }
                               );
                             }
                             else if(state is GetKidDataError)
                             {
                               return Center(child: Text(state.error));
                             }
                             else
                             {
                               return const SizedBox();
                             }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),

                    if(kid != null && school != null)
                    BlocConsumer<CallCubit, CallState>(
                      listener: (context, state) {
                        if (state is CallError) {
                          callMySnackBar(
                              context: context, text: state.error);
                        } else if (state is CallSuccess) {
                          callMySnackBar(context: context, text: TranslationKeyManager.pickupRequestedSuccessfully.tr);
                          Get.to(()=> ResultView(
                            callId: state.id,
                              kid: kid!,
                              school: school!
                          ),
                            duration: const Duration(milliseconds: 500),
                            transition: DelayManager.rightToLeftWithFade,);
                        }
                      },
                      builder: (context, state) {
                        if (state is CallLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return DefaultButton(
                          onTap: () async
                          {
                              CallCubit.get(context).callUp(
                                  kidId: kid!.id!,
                                  schoolModel: school!
                              );

                          },
                          text: TranslationKeyManager.pickup.tr,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          else if(state is GetAllParentKidsLoading)
          {
            return  const Center(child: CircularProgressIndicator());
          }
          else if(state is GetAllParentKidsError)
          {
            return Scaffold(body: Center(child: Text(state.error)),);
          }
          else
          {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

