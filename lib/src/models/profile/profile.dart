import 'social_links.dart';
import 'supports.dart';

class Profile {
  Profile.fromJson(dynamic json) {
    publicID = json['public_id'];
    username = json['username'];
    balance = json['balance'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    displayName = json['displayname'];
    avatar = json['avatar'];
    unreadNotifications = json['unread_notifications'];
    isVerified = json['is_verified'];
    bio = json['bio'];
    professionalRole = json['professional_role'];
    supports =
        json['supports'] != null ? Supports.fromJson(json['supports']) : null;
    socialLinks = [];
    if (json['social_links'] != null) {
      json['social_links'].forEach((v) {
        socialLinks.add(SocialLinks.fromJson(v));
      });
    }
  }

  String? publicID;
  String? username;
  int? balance;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? phoneNumber;
  String? displayName;
  String? avatar;
  int? unreadNotifications;
  bool? isVerified;
  String? bio;
  String? professionalRole;
  Supports? supports;
  late List<SocialLinks> socialLinks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['public_id'] = publicID;
    map['username'] = username;
    map['balance'] = balance;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['country_code'] = countryCode;
    map['phone_number'] = phoneNumber;
    map['displayname'] = displayName;
    map['avatar'] = avatar;
    map['unread_notifications'] = unreadNotifications;
    map['is_verified'] = isVerified;
    map['bio'] = bio;
    map['professional_role'] = professionalRole;
    if (supports != null) {
      map['supports'] = supports?.toJson();
    }
    map['social_links'] = socialLinks.map((v) => v.toJson()).toList();
    return map;
  }
}
