import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/more/default_add_item_row.dart';
import 'package:call_son/core/core_widgets/more/default_add_row.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/feature/school/presentation/cubit/edit_school_levels_cubit/edit_school_levels_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/get_school_levels_cubit/get_school_levels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolEditLevels extends StatefulWidget {
  const SchoolEditLevels({super.key});

  @override
  State<SchoolEditLevels> createState() => _SchoolEditLevelsState();
}

class _SchoolEditLevelsState extends State<SchoolEditLevels> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Edit Levels", showPopup: true,),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: BlocBuilder<GetSchoolLevelsCubit, GetSchoolLevelsState>(
            builder: (context, state) {
              if(state is GetSchoolLevelsLoading)
              {
                return const Center(child: CircularProgressIndicator(),);
              }
              else if(state is GetSchoolLevelsSuccess)
              {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children:
                    [
                      DefaultAddRow(
                        text: "Levels",
                        number: state.levels.length,
                        onPressed: () {
                          setState(() {
                            state.levels.add(LevelModel(isNew: true));
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index)
                        {
                          if(!state.levels[index].isDeleted)
                          {
                            return DefaultAddItemRow(
                              controller: state.levels[index].controller,
                              onTapButton: () {
                                setState(() {
                                  if (state.levels.length > 1) {
                                    state.levels[index].isDeleted = true;
                                  }
                                });
                              },
                            );
                          }
                          else
                          {
                            return const SizedBox();
                          }
                        },
                        itemCount: state.levels.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(
                          height: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      BlocConsumer<EditSchoolLevelsCubit, EditSchoolLevelsState>(
                        listener: (context, state) {
                          if(state is EditSchoolLevelsError)
                          {
                            callMySnackBar(context: context, text: state.error);
                          }
                          else if(state is EditSchoolLevelsSuccess)
                          {
                            callMySnackBar(context: context, text: 'Levels Edited Successfully');
                          }
                        },
                        builder: (context, editState) {
                          if(editState is EditSchoolLevelsLoading)
                          {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          return DefaultButton(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  EditSchoolLevelsCubit.get(context).editLevels(levels: state.levels);
                                }
                              },
                              text: "Edit");
                        },
                      ),

                    ],
                  ),
                );
              }
              else if(state is GetSchoolLevelsError)
              {
                return Center(child: Text(state.error),);
              }
              else
              {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
