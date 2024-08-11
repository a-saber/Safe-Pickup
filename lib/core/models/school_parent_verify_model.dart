
class SchoolParentVerifyModel
{
  String? id;
  String? schoolId;
  String? superParentId;
  bool? isVerified;

  SchoolParentVerifyModel({
    this.id,
    this.schoolId,
    this.superParentId,
    this.isVerified,
  });

  SchoolParentVerifyModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    schoolId = json['schoolId'];
    superParentId = json['superParentId'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson()
  {
    return
      {
        'id' : id,
        'schoolId' : schoolId,
        'superParentId' : superParentId,
        'isVerified' : isVerified,
      };
  }

}