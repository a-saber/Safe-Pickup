import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_all_schools/get_all_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'edit_kid_view.dart';
import 'widgets/edit_kid_data.dart';
import 'widgets/school_level_card_builder.dart';

class KidDetailsView extends StatelessWidget {
  const KidDetailsView({super.key, required this.kid});

  final KidModel kid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetKidDataCubit, GetKidDataState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorsManager.white.withOpacity(0.75),
        appBar: CustomAppBar(
            title: 'Schools', showPopup: true,
          actions: 
          [
            IconButton(
              onPressed: ()
              {
                Get.to(()=> EditKidData(kid: kid),
                    duration: const Duration(milliseconds: 500),
                    transition: DelayManager.rightToLeftWithFade);
              }, icon: const Icon(IconlyLight.edit, size: 20,))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 30,),
          onPressed: ()
          {
            GetAllSchoolsCubit.get(context).getAllSchools();
            Get.to(
                  () => NewKidSchool(
                kid: kid,
              ),
              duration: const Duration(milliseconds: 500),
              transition: DelayManager.rightToLeftWithFade,
            );
          }),
        body: Builder(builder: (context) {
          if (state is GetKidDataError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is GetKidDataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetKidDataSuccess) {
            kid.schools = GetKidDataCubit.get(context).schools;
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemBuilder: (context, index) => SchoolLevelCardBuilder(
                    level: kid.schools[index].kidLevelModel!,
                    kid: kid,
                    school: kid.schools[index],
                  ),
                  itemCount: kid.schools.length,
                ));
          } else {
            return const SizedBox();
          }
        }),
      );
    });
  }
}


