import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/call_model.dart';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'guardian_history_repo.dart';

class GuardianHistoryRepoImplementation extends GuardianHistoryRepo {

  @override
  Future<Either<Failure, CallData>> getCalls() async
  {
    try
    {
      // CallData callData= CallData();
      // var callsResponse = await FirebaseFirestore.instance
      // .collection(CollectionManager.callCollection)
      // .where('guardianId', isEqualTo: GuardianParent.guardianModel.id)
      // .orderBy('dateTime', descending: true)
      // .get();
      //
      // if(callsResponse.docs.isEmpty)
      // {
      //   return left(DataFailure('there are no calls yet'));
      // }
      // else
      // {
      //   await Future.forEach(
      //     callsResponse.docs,
      //     (callMap) async{
      //       CallModel? call = CallModel.fromJson(callMap.data());
      //       await Future.forEach(
      //           GuardianParent.guardianModel.kidsModels,
      //         (kid) async
      //         {
      //           if(call.kidId == kid.id)
      //           {
      //             call.kidModel = kid;
      //             await Future.forEach(
      //               kid.schoolData,
      //               (school) {
      //                 if(school!.id == call.schoolId)
      //                 {
      //                   call.schoolModel = school;
      //                 }
      //               });
      //           }
      //         });
      //       if(call.status == '0')
      //       {
      //         callData.rejectedCalls.add(call);
      //       }
      //       else if(call.status == '1')
      //       {
      //         callData.acceptedCalls.add(call);
      //       }
      //       else
      //       {
      //         callData.waitingCalls.add(call);
      //       }
      //     }
      //   );
      // }
      // return right(callData);
    return  right(CallData());
    }
    catch(e)
    {
      print(e.toString());
      if (e is FirebaseAuthException)
      {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));

    }

  }

}
