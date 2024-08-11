import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/school/presentation/views/widgets/school_guardian_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/core_widgets/pop_up/copy_clipboard.dart';
import '../../../../../core/resources_manager/constants_manager.dart';
import '../../../../../core/models/parent_model.dart';

class SchoolGuardiansViewBody extends StatelessWidget {
  const SchoolGuardiansViewBody({super.key,});

  @override
  Widget build(BuildContext context) {
    print(GetSchoolCubit.get(context).schoolModel!.id);
    final Stream<QuerySnapshot> stream=FirebaseFirestore.instance
    .collection(CollectionManager.schoolParentsCollection)
    .where('schoolId',isEqualTo: GetSchoolCubit.get(context).schoolModel!.id)
    .where('verified', isEqualTo: false)
    .orderBy('createdAt').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
      {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if(snapshot.data!.docs.isEmpty)
        {
          return Center(child: Text('No Data'),);
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
            DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 400,
                columns: [
                  DataColumn(
                    label:  Center(child: Text('Name')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Phone')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Kids')),
                  ),
                  DataColumn(
                    label: Center(child: Text('More details')),
                  ),
                ],
                rows: List<DataRow>.generate(
                    snapshot.data!.docs.length,
                        (index)
                    {
                      return DataRow(
                          cells:
                          [
                            DataCell(Center(child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
                                  .doc(snapshot.data!.docs[index].id).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData && !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  ParentModel guardian = ParentModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                  return Text(guardian.name!,textAlign: TextAlign.center);
                                }

                                return Text("loading");
                              },
                            ))),
                            DataCell(Center(child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
                                  .doc(snapshot.data!.docs[index].id).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData && !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  ParentModel guardian = ParentModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                  return InkWell(
                                      onTap: ()
                                      {
                                        copyToClipBoard(context: context, text: guardian.phone! );
                                      },
                                      child: Text(
                                          '${guardian.phone}',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ,textAlign: TextAlign.center
                                      )
                                  );
                                }

                                return Text("loading");
                              },
                            ))),
                            DataCell(Center(child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection(CollectionManager.schoolsCollection)
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection(CollectionManager.parentsCollection)
                                  .doc(snapshot.data!.docs[index].id).collection(CollectionManager.kidsCollection)
                                  .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                            {
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              return Center(child: Text('${snapshot.data!.docs.length}'),);
                            },))),
                            DataCell(Center(
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context)=>SchoolGuardianDetailsView(guardianId: snapshot.data!.docs[index].id,)));
                                }, child: Text('Details')
                              )
                            )),
                          ]);
                    }

                )
            ),
          ),
        );
      },
    );
  }
}


// class SchoolParentCardBuilder extends StatelessWidget {
//   const SchoolParentCardBuilder({super.key, required this.parent});
//
//   final ParentModel parent;
//   @override
//   Widget build(BuildContext context) {
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 10),
//       color: ColorsManager.white,
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${parent.name }',
//               style: StyleManager.semiBold
//                   .copyWith(fontSize: 15.0),
//             ),
//             const SizedBox(height: 3.5,),
//             Text(
//               parent.ssn ?? '',
//               style: StyleManager.medium
//                   .copyWith(fontSize: 15.0),
//             ),
//             const SizedBox(height: 3.5,),
//             InkWell(
//                 onTap: ()
//                 {
//                   copyToClipBoard(context: context, text: parent.phone! );
//                 },
//                 child: Row(
//                   children:
//                   [
//                     const Icon(IconlyLight.call, size: 15,color: ColorsManager.grey,),
//                     const SizedBox(width: 5,),
//                     Text(
//                       parent.phone!,
//                       style: StyleManager.semiBold.copyWith(
//                           color: ColorsManager.grey,
//                           fontSize: 12.0
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//
//             const SizedBox(height: 3.5,),
//               Row(
//                 children:
//                 [
//                   BlocConsumer<ChangeCallStatusCubit, ChangeCallStatusState>(
//                     listener: (context, state) {
//                       if (state is ChangeCallStatusError)
//                       {
//                         callMySnackBar(context: context, text: state.error);
//                       }
//                       if(state is ChangeCallStatusSuccess)
//                       {
//                         Navigator.pop(context);
//                       }
//                     },
//                     builder: (context, state) {
//                       if(state is ChangeCallStatusLoading)
//                       {
//                         return const Center(child: CircularProgressIndicator(),);
//                       }
//                       else
//                       {
//                         return Expanded(
//                           child: DefaultButton(
//                               text: 'Accept',
//                               onTap: ()
//                               {
//                                 ChangeCallStatusCubit.get(context).changeCallStatus(
//                                   callId: call.id!,
//                                   accepted: true,
//                                 );
//                               }),
//                         );
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 10,),
//                   Expanded(
//                     child: DefaultButton(
//                       buttonColor:  ColorsManager.secondary,
//                       onTap: ()
//                       {
//                         showDialog(
//                             context: context,
//                             builder: (context) => alertReject(context, call: call)
//                         );
//                       },
//                       text: 'Reject',
//                     ),
//                   ),
//                 ],
//               ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
// Widget alertNotAccepted(context, {required String parentId})
// {
//   final formKey = GlobalKey<FormState>();
//   final reply = TextEditingController();
//   return AlertDialog(
//     insetPadding: EdgeInsets.zero,
//     contentPadding: EdgeInsets.zero,
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(30.0))),
//     content: Form(
//       key: formKey,
//       child: Builder(
//         builder: (context) {
//           // Get available height and width of the build area of this widget. Make a choice depending on the size.
//           var height = MediaQuery.of(context).size.height;
//           var width = MediaQuery.of(context).size.width;
//
//           return Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: ColorsManager.white,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             width: width * 0.35,
//             height: height * 0.5,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Explain to the guardian, why you did not accept the request !',
//                   textAlign: TextAlign.center,
//                   style: StyleManager.regular.copyWith(
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 DefaultFormField(
//                     labelText: 'Reason',
//                     controller: reply),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: MaterialButton(
//                           color: ColorsManager.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Text('Cancel',
//                                 style: StyleManager.regular.copyWith(
//                                   color: Colors.white,
//                                   fontSize: 19,
//                                 )),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           }),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     BlocConsumer<ChangeCallStatusCubit, ChangeCallStatusState>(
//                       listener: (context, state) {
//                         if (state is ChangeCallStatusError)
//                         {
//                           callMySnackBar(context: context, text: state.error);
//                         }
//                         if(state is ChangeCallStatusSuccess)
//                         {
//                           Navigator.pop(context);
//                         }
//                       },
//                       builder: (context, state) {
//                         if(state is ChangeCallStatusLoading)
//                         {
//                           return const Center(child: CircularProgressIndicator(),);
//                         }
//                         else
//                         {
//                           return Expanded(
//                             child: MaterialButton(
//                                 color: ColorsManager.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                   side: const BorderSide(
//                                       color: ColorsManager.primary, width: 2),
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                   const EdgeInsets.symmetric(vertical: 10),
//                                   child: Text('Reject',
//                                       style: StyleManager.regular.copyWith(
//                                         color: ColorsManager.primary,
//                                         fontSize: 19,
//                                       )),
//                                 ),
//                                 onPressed: ()
//                                 {
//                                   if (formKey.currentState!.validate())
//                                   {
//                                     ChangeCallStatusCubit.get(context).changeCallStatus(
//                                       callId: call.id!,
//                                       accepted: false,
//                                       reply: reply.text,
//                                     );
//                                   }
//                                 }),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }