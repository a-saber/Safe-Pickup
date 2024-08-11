
class SchoolKidModel
{
  String? id;
  String? kidId;
  String? schoolId;
  bool? verified;

  SchoolKidModel({ this.kidId,  this.schoolId, this.verified = false, this.id});


  Map<String, dynamic> toJson() => {
    'kidId': kidId,
    'schoolId': schoolId,
    'verified': verified,
    'id': id
  };

  factory SchoolKidModel.fromJson(Map<String, dynamic> json) => SchoolKidModel(
    kidId: json['kidId'],
    schoolId: json['schoolId'],
    verified: json['verified'],
    id: json['id']
  );
}
