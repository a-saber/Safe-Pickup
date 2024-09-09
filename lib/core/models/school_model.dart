import 'package:image_picker/image_picker.dart';

import 'level_model.dart';

class SchoolModel
{
  String? id;
  String? fcmToken;
  String? name;
  String? location;
  String? email;
  String? password;
  String? phone;
  bool? ssnRequired;
  String? imagePath;
  double? long;
  double? lat;
  List<LevelModel> levels =[];

  // data for ui not stored in firebase
  XFile? image;
  LevelModel? kidLevelModel;
  List<LevelModel> kidLevels =[];

  SchoolModel({
    this.id,
    this.name,
    this.email,
    this.location,
    this.password,
    this.phone,
    this.long,
    this.lat,
    this.imagePath,
    this.ssnRequired,
  });

  SchoolModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    fcmToken = json['fcmToken'];
    phone = json['phone'];
    name = json['name'];
    location = json['location'];
    email = json['email'];
    long = json['long'];
    lat = json['lat'];
    imagePath = json['imagePath'];
    ssnRequired = json['ssnRequired'];
  }

  Map<String, dynamic> toJsonRegister()
  {
    return
      {
        'name' : name,
        'email' : email,
        'location' : location,
        'id' : id,
        'phone' : phone,
        'long' : long,
        'lat' : lat,
        'imagePath' : imagePath,
        'ssnRequired' : ssnRequired,
      };
  }
  Map<String, dynamic> toJsonUpdate()
  {
    return
      {
        'name' : name,
        'phone' : phone,
        'location' : location,
        'imagePath' : imagePath,
        'ssnRequired' : ssnRequired,
      };
  }
  Map<String, dynamic> toJsonUpdateLocation()
  {
    return
      {
        'long' : long,
        'lat' : lat,
      };
  }
  Map<String, dynamic> toJsonUpdateFCMToken()
  {
    return
      {
        'fcmToken' : fcmToken,
      };
  }
}

