import 'dart:convert';

import 'package:bureau_couple/getx/data/response/profile_model.dart';

class UserConnectionResponse {
  final List<UserConnection>? data;
  // final String? firstPageUrl;
  // final String? from;
  // final int? lastPage;
  // final String? lastPageUrl;
  // final List<Link>? links;

  UserConnectionResponse({
     this.data,
     // this.firstPageUrl,
     // this.from,
     // this.lastPage,
     // this.lastPageUrl,
     // this.links,
  });

  factory UserConnectionResponse.fromJson(Map<String, dynamic> json) {
    return UserConnectionResponse(
      data: ((json['data'] ?? []) as List).map((e) => UserConnection.fromJson(e)).toList(),
      // firstPageUrl: json['first_page_url'] ?? "",
      // from: json['from'] ?? "",
      // lastPage: json['last_page'] ??"",
      // lastPageUrl: json['last_page_url'] ?? "",
      // links: ((json['links'] ?? []) as List).map((e) => Link.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': (data ?? []).map((e) => e.toJson()).toList(),
      // 'first_page_url': firstPageUrl,
      // 'from': from,
      // 'last_page': lastPage,
      // 'last_page_url': lastPageUrl,
      // 'links': (links ?? []).map((e) => e.toJson()).toList(),
    };
  }
}

class UserConnection {
  final int id;
  final int userId;
  final int interestingId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final User user;
  final Profile profile;
  final Conversation conversation;

  UserConnection({
    required this.id,
    required this.userId,
    required this.interestingId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.profile,
    required this.conversation,
  });

  factory UserConnection.fromJson(Map<String, dynamic> json) {
    return UserConnection(
      id: json['id'],
      userId: json['user_id'],
      interestingId: json['interesting_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
      profile: Profile.fromJson(json['profile']),
      conversation: Conversation.fromJson((json['conversation'] ?? Conversation(id: 0, interestId: 0, senderId: 0, receiverId: 0).toJson())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'interesting_id': interestingId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toJson(),
      'profile': profile.toJson(),
      'conversation': conversation.toJson(),
    };
  }
}

class User {
  final int id;
  final int profileId;
  final String firstname;
  final String lastname;
  final String username;
  final Address address;
  final String email;
  final String mobile;
  final String image;
  final String? currentUserImage;
  final String? OtherUserIamge;

  // final List<Interest> interest;

  User({
    required this.id,
    required this.profileId,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.address,
    required this.email,
    required this.mobile,
    required this.image,
    this.currentUserImage,
    this.OtherUserIamge,
    // required this.interest,
    // required this.basicInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      profileId: json['profile_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      address: Address.fromJson(json['address']),
      email: json['email'],
      mobile: json['mobile'],
      image: json['image'],
      currentUserImage: json['current_user_image'],
      OtherUserIamge: json['other_user_image'],
      // basicInfo: BasicInfo.fromJson((json['basic_info'] ?? BasicInfo().toJson())),
      // interest: (json['interest'] as List).map((e) => Interest.fromJson(e)).toList(), basicInfo: BasicInfo.fromJson(json['basic_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'address': address.toJson(),
      'email': email,
      'mobile': mobile,
      'image': image,
      'current_user_image': currentUserImage,
      'other_user_image': OtherUserIamge,
    };
  }
}

class Profile {
  final int id;
  final String firstname;
  final String lastname;
  final Address address;
  final BasicInfo? basicInfo;

  Profile({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.address,
     this.basicInfo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      address: Address.fromJson(json['address']),
      basicInfo: BasicInfo.fromJson(json['basic_info'] ?? BasicInfo().toJson()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'address': address.toJson(),
      'basic_info': basicInfo?.toJson(),
    };
  }
}

class Address {
  final String? district;
  final String state;
  final String? zip;
  final String country;

  Address({
    required this.district,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      district: json['district'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }
}

class Interest {
  final String interestName;
  final List<String> hobbies;

  Interest({
    required this.interestName,
    required this.hobbies,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      interestName: json['interest_name'],
      hobbies: List<String>.from(json['hobbies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interest_name': interestName,
      'hobbies': hobbies,
    };
  }
}

class Conversation {
  final int id;
  final int interestId;
  final int senderId;
  final int receiverId;

  Conversation({
    required this.id,
    required this.interestId,
    required this.senderId,
    required this.receiverId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      interestId: json['interest_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interest_id': interestId,
      'sender_id': senderId,
      'receiver_id': receiverId,
    };
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
