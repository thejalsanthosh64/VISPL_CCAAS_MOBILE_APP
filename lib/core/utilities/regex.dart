abstract class AppRegEx {
  static final emailRegEx = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static final checkEnglishLetter =  RegExp(r'^[a-zA-Z]');


  static final indianNo = RegExp(r'^[6-9]\d{9}$');
}
