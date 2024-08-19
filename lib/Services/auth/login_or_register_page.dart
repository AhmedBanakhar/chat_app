import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
//تقوم هذه الداله بالتبديل بين صفحه تسجيل الدخول وانساء حساب
//هذه كان المتغير يحمل قيمه الصح ف ان الصفحه ستكون صفحه تسحيل الدخول
//اذا كان المتغبر يحمل قيمه الخطا ف ان الصفحه ستكون انشاء حساب
  void togglePages() {
    setState(() {
      //يعمل عللا عكس القيمه للمتغير اذا كان صح يتحول خطا والعكس صحيح على شان يعمل تبديل بين الصفحات
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegsiterPage(
        onTap: togglePages,
      );
    }
  }
}
