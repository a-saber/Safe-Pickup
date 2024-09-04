import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/feature/guardian/presentation/cubit/search_schools/search_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/search_schools/search_schools_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'widgets/school_level_card_builder.dart';

class ParentSearchForSchoolView extends StatefulWidget {
  const ParentSearchForSchoolView({super.key});

  @override
  State<ParentSearchForSchoolView> createState() => _ParentSearchForSchoolViewState();
}

class _ParentSearchForSchoolViewState extends State<ParentSearchForSchoolView> {
  final searchController = TextEditingController();
@override
  void initState() {
    SearchSchoolsCubit.get(context).init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title: TranslationKeyManager.searchForSchool.tr,
        showPopup: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DefaultFormField(
              controller: searchController,
              labelText: TranslationKeyManager.search.tr,
              textInputType: TextInputType.name,
              suffixIcon: const Icon(
                IconlyLight.search,
                color: ColorsManager.primary,
              ),
              onChange: (String? value) {
                if (value!.isNotEmpty) {
                  SearchSchoolsCubit.get(context)
                      .searchSchools(schoolName: value);
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<SearchSchoolsCubit, SearchSchoolsState>(
                builder: (context, state) {
              if (state is SearchSchoolsLoading)
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if (state is SearchSchoolsFailure)
              {
                return Text(state.failure.errorMessage);
              }
              else if(searchController.text.isEmpty)
              {
                return const SizedBox();
              }
              else if (state is SearchSchoolsSuccess)
              {
                return Expanded(
                  child: ListView.builder(
                    itemCount: SearchSchoolsCubit.get(context).schools.length,
                    itemBuilder: (context , index)=> SchoolCardBuilder(
                      school: SearchSchoolsCubit.get(context).schools[index]
                    )
                  )
                );
              }
              else
              {
                return const SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
