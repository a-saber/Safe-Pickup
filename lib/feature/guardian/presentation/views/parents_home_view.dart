import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_nearby_schools/get_nearby_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_nearby_schools/get_nearby_schools_state.dart';
import 'package:call_son/feature/guardian/presentation/views/widgets/custom_floating_action_button.dart';
import 'package:call_son/feature/guardian/presentation/views/widgets/school_level_card_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import 'widgets/custom_drawer.dart';

class ParentsHomeView extends StatelessWidget {
  const ParentsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(IconlyLight.category),),
      ),
      drawer: CustomDrawer(scaffoldKey: scaffoldKey,),
      floatingActionButton: const CustomFloatingActionButton(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children:
          [
            DefaultFormField(
              controller: TextEditingController(),
              labelText: 'Search',
              textInputType: TextInputType.text,
              suffixIcon: const Icon(
                IconlyLight.search,
                color: ColorsManager.primary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            BlocConsumer<GetNearBySchoolsCubit, GetNearBySchoolsState>
              (
              listener: (context, state) {},
              builder: (context, state) {
                if(state is GetNearBySchoolsLoading)
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(state is GetNearBySchoolsSuccess)
                {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        const Text('Near By Schools', style: StyleManager.semiBold,),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: GetNearBySchoolsCubit.get(context).schools.length,
                            itemBuilder: (context, index) => SchoolCardBuilder(school: GetNearBySchoolsCubit.get(context).schools[index],)
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else if(state is GetNearBySchoolsFailure)
                {
                  return Center(child: Text(state.failure.errorMessage),);
                }
                else
                {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
