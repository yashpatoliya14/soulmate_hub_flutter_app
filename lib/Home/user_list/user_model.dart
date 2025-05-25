class UserModel {
  final String? FULLNAME;
  final String? EMAIL;
  final int? MOBILE;
  final String? PASSWORD;
  final String? DOB;
  final String? GENDER;
  final String? CITY;
  final List<String>? HOBBIES;
  final bool? ISFAVORITE;
  final String? AGE;
  final String? PROFILEPHOTO;
  final bool? ISVERIFIED;
  final String? USERNAME;
  final bool? ISPROFILEDETAILS;
  final List<String>? FAVORITELIST;
  UserModel({
      this.USERNAME,
      this.ISVERIFIED,
     this.FULLNAME,
     this.EMAIL,
     this.MOBILE,
     this.PASSWORD,
     this.DOB,
     this.GENDER,
     this.CITY,
     this.HOBBIES,
     this.ISFAVORITE,
     this.AGE,
     this.PROFILEPHOTO,
    this.ISPROFILEDETAILS,
    this.FAVORITELIST
  });

  Map<String, dynamic> toJson() {
    return {
      if (FULLNAME != null) 'name': FULLNAME,
      if (EMAIL != null) 'email': EMAIL,
      if (MOBILE != null) 'mobile': MOBILE,
      if (PASSWORD != null) 'password': PASSWORD,
      if (DOB != null) 'dob': DOB,
      if (GENDER != null) 'gender': GENDER,
      if (CITY != null) 'city': CITY,
      if (HOBBIES != null) 'hobbies': HOBBIES,
      'isFavorite': ISFAVORITE ?? false,
      if (ISVERIFIED!=null) 'isVerified' : ISVERIFIED,
      if (AGE != null) 'age': AGE,
      if (PROFILEPHOTO != null) 'profilePhoto': PROFILEPHOTO,
      if (ISPROFILEDETAILS != null) 'isProfileDetails': ISPROFILEDETAILS,
      if (FAVORITELIST !=null) 'favoriteList' : FAVORITELIST
    };
  }

}
