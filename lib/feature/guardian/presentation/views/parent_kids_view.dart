import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'kid_details_view.dart';

class ParentKidsView extends StatelessWidget {
  const ParentKidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Kids', showPopup: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<GetAllParentKidsCubit, GetAllParentKidsState>(
          builder: (context, state)
          {
            if(state is GetAllParentKidsError)
            {
              return Center(child: Text(state.error),);
            }
            else if (state is GetAllParentKidsLoading)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is GetAllParentKidsSuccess)
            {
              return ListView.builder(
                itemCount: GetAllParentKidsCubit.get(context).kids.length,
                itemBuilder: (context, index) => KidCardBuilder(kid: GetAllParentKidsCubit.get(context).kids[index]),
              );
            }
            else
            {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class KidCardBuilder extends StatelessWidget {
  const KidCardBuilder({super.key, required this.kid});

  final KidModel kid;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsManager.white,
      margin:  const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<GetKidDataCubit, GetKidDataState>(
        builder: (context, state) {
          return InkWell(
              onTap: ()
              {
                if( GetKidDataCubit.get(context).kidId!=kid.id)
                {
                  GetKidDataCubit.get(context).getKidData(kidId: kid.id!);
                }
                Get.to(()=> KidDetailsView(kid: kid),
                duration: const Duration(milliseconds: 500),
                transition: DelayManager.rightToLeftWithFade);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children:
                  [
                    const Icon(IconlyLight.profile),
                    const SizedBox(width: 10,),
                    Text(kid.name !=null? kid.name!.capitalize! :'',
                      style: StyleManager.regular.copyWith(
                      fontSize: 18.0,
                    ),),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
