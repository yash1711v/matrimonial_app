class MatchesModel {
  int? id;
  int? profileId;
  String? firstname;
  String? lastname;
  int? lookingFor;
  String? username;
  Address? address;
  String? email;
  String? countryCode;
  String? mobile;
  String? balance;
  int? status;

  String? image;
  String? createdAt;
  String? updatedAt;
  String? bloodGroup;
  dynamic? religion;
  String? maritalStatus;
  dynamic? motherTongue;
  dynamic? community;
  String? gender;
  dynamic? profession;
  String? middleName;
  String? fun;
  String? fitness;
  String? otherInterest;
  String? creative;
  String? hobby;
  dynamic? communityName;
  dynamic? motherTongueName;
  dynamic? religionName;
  dynamic? professionName;
  int? bookmark;
  int? interestStatus;
  BasicInfo? basicInfo;
  String? bloodGroups;
  Map<String, dynamic>? maritialStatus;
  PartnerExpectation? partnerExpectation;
  PhysicalAttributes? physicalAttributes;
  String? family;
  List<CareerInfo>? careerInfo;
  List<EducationInfo>? educationInfo;
  String? limitation;

  MatchesModel(
      {this.id,
        this.profileId,
        this.firstname,
        this.lastname,
        this.lookingFor,
        this.username,
        this.address,
        this.email,
        this.countryCode,
        this.mobile,
        this.balance,
        this.status,

        this.image,
        this.createdAt,
        this.updatedAt,
        this.bloodGroup,
        this.religion,
        this.maritalStatus,
        this.motherTongue,
        this.community,
        this.gender,
        this.profession,
        this.middleName,
        this.fun,
        this.fitness,
        this.otherInterest,
        this.creative,
        this.hobby,
        this.communityName,
        this.motherTongueName,
        this.religionName,
        this.professionName,
        this.bookmark,
        this.interestStatus,
        this.basicInfo,
        this.bloodGroups,
        this.maritialStatus,
        this.partnerExpectation,
        this.physicalAttributes,
        this.family,
        this.careerInfo,
        this.educationInfo,
        this.limitation,
      });

  MatchesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    lookingFor = json['looking_for'];
    username = json['username'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    balance = json['balance'];
    status = json['status'];

    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bloodGroup = json['blood_group'];
    religion = json['religion'];
    maritalStatus = json['marital_status'];
    motherTongue = json['mother_tongue'];
    community = json['community'];
    gender = json['gender'];
    profession = json['profession'];
    middleName = json['middle_name'];
    fun = json['fun'];
    fitness = json['fitness'];
    otherInterest = json['other_interest'];
    creative = json['creative'];
    hobby = json['hobby'];
    communityName = json['community_name'];
    motherTongueName = json['mother_tongue_name'];
    religionName = json['religion_name'];
    professionName = json['profession_name'];
    bookmark = json['bookmark'];
    interestStatus = json['interestStatus'];
    basicInfo = json['basic_info'] != null
        ? new BasicInfo.fromJson(json['basic_info'])
        : null;
    bloodGroups = json['blood_groups'];
    maritialStatus = json['maritial_status'];
    partnerExpectation = json['partner_expectation'] != null
        ? new PartnerExpectation.fromJson(json['partner_expectation'])
        : null;
    physicalAttributes = json['physical_attributes'] != null
        ? new PhysicalAttributes.fromJson(json['physical_attributes'])
        : null;
    family = json['family'];
    if (json['career_info'] != null) {
      careerInfo = <CareerInfo>[];
      json['career_info'].forEach((v) {
        careerInfo!.add(new CareerInfo.fromJson(v));
      });
    }
    if (json['education_info'] != null) {
      educationInfo = <EducationInfo>[];
      json['education_info'].forEach((v) {
        educationInfo!.add(new EducationInfo.fromJson(v));
      });
    }
    limitation = json['limitation'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['looking_for'] = this.lookingFor;
    data['username'] = this.username;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['balance'] = this.balance;
    data['status'] = this.status;

    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['blood_group'] = this.bloodGroup;
    data['religion'] = this.religion;
    data['marital_status'] = this.maritalStatus;
    data['mother_tongue'] = this.motherTongue;
    data['community'] = this.community;
    data['gender'] = this.gender;
    data['profession'] = this.profession;
    data['middle_name'] = this.middleName;
    data['fun'] = this.fun;
    data['fitness'] = this.fitness;
    data['other_interest'] = this.otherInterest;
    data['creative'] = this.creative;
    data['hobby'] = this.hobby;
    data['community_name'] = this.communityName;
    data['mother_tongue_name'] = this.motherTongueName;
    data['religion_name'] = this.religionName;
    data['profession_name'] = this.professionName;
    data['bookmark'] = this.bookmark;
    data['interestStatus'] = this.interestStatus;
    if (this.basicInfo != null) {
      data['basic_info'] = this.basicInfo!.toJson();
    }
    data['blood_groups'] = this.bloodGroups;
    data['maritial_status'] = this.maritialStatus;
    if (this.partnerExpectation != null) {
      data['partner_expectation'] = this.partnerExpectation!.toJson();
    }
    if (this.physicalAttributes != null) {
      data['physical_attributes'] = this.physicalAttributes!.toJson();
    }
    data['family'] = this.family;
    if (this.careerInfo != null) {
      data['career_info'] = this.careerInfo!.map((v) => v.toJson()).toList();
    }
    if (this.educationInfo != null) {
      data['education_info'] =
          this.educationInfo!.map((v) => v.toJson()).toList();
    }
    data['limitation'] = this.limitation;

    return data;
  }
}

class Address {
  String? address;
  String? district;
  String? state;
  String? zip;
  String? country;

  Address({this.address, this.district, this.state, this.zip, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    district = json['district'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['district'] = this.district;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['country'] = this.country;
    return data;
  }
}

class BasicInfo {
  int? id;
  int? userId;
  int? userType;
  String? gender;
  String? profession;
  String? financialCondition;
  String? religion;
  int? smokingStatus;
  int? drinkingStatus;
  String? birthDate;
  String? maritalStatus;
  PresentAddress? presentAddress;
  PermanentAddress? permanentAddress;
  String? createdAt;
  String? updatedAt;
  String? community;
  String? motherTongue;
  String? aboutUs;
  int? age;
  String? batchStart;
  String? cadar;
  String? batchEnd;
  String? religionName;
  String? communityName;
  String? professionName;
  String? motherTongueName;
  String? smoking;
  String? drinking;

  BasicInfo(
      {this.id,
        this.userId,
        this.userType,
        this.gender,
        this.profession,
        this.financialCondition,
        this.religion,
        this.smokingStatus,
        this.drinkingStatus,
        this.birthDate,

        this.maritalStatus,
        this.presentAddress,
        this.permanentAddress,
        this.createdAt,
        this.updatedAt,
        this.community,
        this.motherTongue,
        this.aboutUs,
        this.age,
        this.batchStart,
        this.cadar,
        this.batchEnd,
        this.religionName,
        this.communityName,
        this.professionName,
        this.motherTongueName,
        this.smoking,
        this.drinking});

  BasicInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    gender = json['gender'];
    profession = json['profession'];
    financialCondition = json['financial_condition'];
    religion = json['religion'];
    smokingStatus = json['smoking_status'];
    drinkingStatus = json['drinking_status'];
    birthDate = json['birth_date'];

    maritalStatus = json['marital_status'];
    presentAddress = json['present_address'] != null
        ? new PresentAddress.fromJson(json['present_address'])
        : null;
    permanentAddress = json['permanent_address'] != null
        ? new PermanentAddress.fromJson(json['permanent_address'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    community = json['community'];
    motherTongue = json['mother_tongue'];
    aboutUs = json['about_us'];
    age = json['age'];
    batchStart = json['batch_start'];
    cadar = json['cadar'];
    batchEnd = json['batch_end'];
    religionName = json['religion_name'];
    communityName = json['community_name'];
    professionName = json['profession_name'];
    motherTongueName = json['mother_tongue_name'];
    smoking = json['smoking'];
    drinking = json['drinking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['gender'] = this.gender;
    data['profession'] = this.profession;
    data['financial_condition'] = this.financialCondition;
    data['religion'] = this.religion;
    data['smoking_status'] = this.smokingStatus;
    data['drinking_status'] = this.drinkingStatus;
    data['birth_date'] = this.birthDate;
    data['marital_status'] = this.maritalStatus;
    if (this.presentAddress != null) {
      data['present_address'] = this.presentAddress!.toJson();
    }
    if (this.permanentAddress != null) {
      data['permanent_address'] = this.permanentAddress!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['community'] = this.community;
    data['mother_tongue'] = this.motherTongue;
    data['about_us'] = this.aboutUs;
    data['age'] = this.age;
    data['batch_start'] = this.batchStart;
    data['cadar'] = this.cadar;
    data['batch_end'] = this.batchEnd;
    data['religion_name'] = this.religionName;
    data['community_name'] = this.communityName;
    data['profession_name'] = this.professionName;
    data['mother_tongue_name'] = this.motherTongueName;
    data['smoking'] = this.smoking;
    data['drinking'] = this.drinking;
    return data;
  }
}

class PresentAddress {
  String? country;
  String? state;
  String? zip;
  String? city;

  PresentAddress({this.country, this.state, this.zip, this.city});

  PresentAddress.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    state = json['state'];
    zip = json['zip'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['city'] = this.city;
    return data;
  }
}

class PermanentAddress {
  String? country;
  String? state;
  String? zip;
  String? city;

  PermanentAddress({this.country, this.state, this.zip, this.city});

  PermanentAddress.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    state = json['state'];
    zip = json['zip'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['city'] = this.city;
    return data;
  }
}

class PartnerExpectation {
  int? id;
  int? userId;
  String? generalRequirement;
  String? country;
  int? minAge;
  int? maxAge;
  String? minHeight;
  String? maxHeight;
  String? maxWeight;
  String? maritalStatus;
  dynamic? religion;
  String? complexion;
  String? smokingStatus;
  String? drinkingStatus;
  String? minDegree;
  String? profession;
  String? personality;
  String? financialCondition;
  String? familyPosition;
  String? createdAt;
  String? updatedAt;
  dynamic? motherTongue;
  dynamic? community;
  dynamic? position;
  dynamic? religionName;
  dynamic? communityName;
  dynamic? professionName;
  dynamic? motherTongueName;
  String? smoking;
  String? drinking;
  String? positionName;
  String? maritialStatus;

  PartnerExpectation(
      {this.id,
        this.userId,
        this.generalRequirement,
        this.country,
        this.minAge,
        this.maxAge,
        this.minHeight,
        this.maxHeight,
        this.maxWeight,
        this.maritalStatus,
        this.religion,
        this.complexion,
        this.smokingStatus,
        this.drinkingStatus,

        this.minDegree,
        this.profession,
        this.personality,
        this.financialCondition,
        this.familyPosition,
        this.createdAt,
        this.updatedAt,
        this.motherTongue,
        this.community,
        this.position,
        this.religionName,
        this.communityName,
        this.professionName,
        this.motherTongueName,
        this.smoking,
        this.drinking,
        this.positionName,
        this.maritialStatus});

  PartnerExpectation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    generalRequirement = json['general_requirement'];
    country = json['country'];
    minAge = json['min_age'];
    maxAge = json['max_age'];
    minHeight = json['min_height'];
    maxHeight = json['max_height'];
    maxWeight = json['max_weight'];
    maritalStatus = json['marital_status'];
    religion = json['religion'];
    complexion = json['complexion'];
    smokingStatus = json['smoking_status'];
    drinkingStatus = json['drinking_status'];

    minDegree = json['min_degree'];
    profession = json['profession'];
    personality = json['personality'];
    financialCondition = json['financial_condition'];
    familyPosition = json['family_position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    motherTongue = json['mother_tongue'];
    community = json['community'];
    position = json['position'].toString();
    religionName = json['religion_name'];
    communityName = json['community_name'];
    professionName = json['profession_name'];
    motherTongueName = json['mother_tongue_name'];
    smoking = json['smoking'];
    drinking = json['drinking'];
    positionName = json['position_name'];
    maritialStatus = json['maritial_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['general_requirement'] = this.generalRequirement;
    data['country'] = this.country;
    data['min_age'] = this.minAge;
    data['max_age'] = this.maxAge;
    data['min_height'] = this.minHeight;
    data['max_height'] = this.maxHeight;
    data['max_weight'] = this.maxWeight;
    data['marital_status'] = this.maritalStatus;
    data['religion'] = this.religion;
    data['complexion'] = this.complexion;
    data['smoking_status'] = this.smokingStatus;
    data['drinking_status'] = this.drinkingStatus;

    data['min_degree'] = this.minDegree;
    data['profession'] = this.profession;
    data['personality'] = this.personality;
    data['financial_condition'] = this.financialCondition;
    data['family_position'] = this.familyPosition;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mother_tongue'] = this.motherTongue;
    data['community'] = this.community;
    data['position'] = this.position;
    data['religion_name'] = this.religionName;
    data['community_name'] = this.communityName;
    data['profession_name'] = this.professionName;
    data['mother_tongue_name'] = this.motherTongueName;
    data['smoking'] = this.smoking;
    data['drinking'] = this.drinking;
    data['position_name'] = this.positionName;
    data['maritial_status'] = this.maritialStatus;
    return data;
  }
}

class PhysicalAttributes {
  int? id;
  int? userId;
  String? height;
  String? weight;
  String? bloodGroup;
  String? eyeColor;
  String? hairColor;
  String? complexion;
  String? disability;
  String? createdAt;
  String? updatedAt;

  PhysicalAttributes(
      {this.id,
        this.userId,
        this.height,
        this.weight,
        this.bloodGroup,
        this.eyeColor,
        this.hairColor,
        this.complexion,
        this.disability,
        this.createdAt,
        this.updatedAt});

  PhysicalAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    height = json['height'];
    weight = json['weight'];
    bloodGroup = json['blood_group'];
    eyeColor = json['eye_color'];
    hairColor = json['hair_color'];
    complexion = json['complexion'];
    disability = json['disability'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['blood_group'] = this.bloodGroup;
    data['eye_color'] = this.eyeColor;
    data['hair_color'] = this.hairColor;
    data['complexion'] = this.complexion;
    data['disability'] = this.disability;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CareerInfo {
  int? id;
  int? userId;
  String? position;
  String? from;
  String? end;
  String? createdAt;
  String? updatedAt;
  String? statePosting;
  String? districtPosting;

  CareerInfo(
      {this.id,
        this.userId,
        this.position,
        this.from,
        this.end,
        this.createdAt,
        this.updatedAt,
        this.statePosting,
        this.districtPosting});

  CareerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    position = json['position'].toString();
    from = json['from'];
    end = json['end'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statePosting = json['state_posting'];
    districtPosting = json['district_posting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['position'] = this.position;
    data['from'] = this.from;
    data['end'] = this.end;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['state_posting'] = this.statePosting;
    data['district_posting'] = this.districtPosting;
    return data;
  }
}

class EducationInfo {
  int? id;
  int? userId;
  String? degree;
  String? fieldOfStudy;
  String? institute;
  int? regNo;
  int? rollNo;
  String? outOf;
  String? result;
  String? createdAt;
  String? updatedAt;

  EducationInfo(
      {this.id,
        this.userId,
        this.degree,
        this.fieldOfStudy,
        this.institute,
        this.regNo,
        this.rollNo,
        this.outOf,
        this.result,
        this.createdAt,
        this.updatedAt});

  EducationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    degree = json['degree'];
    fieldOfStudy = json['field_of_study'];
    institute = json['institute'];
    regNo = json['reg_no'];
    rollNo = json['roll_no'];
    outOf = json['out_of'];
    result = json['result'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['degree'] = this.degree;
    data['field_of_study'] = this.fieldOfStudy;
    data['institute'] = this.institute;
    data['reg_no'] = this.regNo;
    data['roll_no'] = this.rollNo;
    data['out_of'] = this.outOf;
    data['result'] = this.result;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
