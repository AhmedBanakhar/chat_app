// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/Services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfiled.dart';
import 'package:flutter/material.dart';

class RegsiterPage extends StatelessWidget {
  final void Function()? onTap;
  RegsiterPage({super.key, this.onTap});

  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  void register(BuildContext context) async {
    //? instance AuthService
    final auth = AuthService();

    if (_passwordcontroller.text == _confirmpasswordcontroller.text) {
      try {
        await auth.signUpWithEmailPassword(
            _emailcontroller.text, _passwordcontroller.text);
        //? إذا تم التسجيل بنجاح، يمكنك متابعة العملية (مثل الانتقال إلى صفحة تسجيل الدخول)
      } catch (e) {
        //! استخدام دالة getErrorMessage للحصول على رسالة الخطأ المناسبة
        String errorMessage = auth.getErrorMessage(e.toString());

        //! طباعة الخطأ في وحدة التحكم
        // ignore: avoid_print
        print('===========================================$errorMessage');

        //! عرض رسالة الخطأ المناسبة للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
       //! عرض رسالة الخطا في حال لما تكن كلمه المرور متطابقه
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('خطأ'),
          content: Text('كلمة المرور غير متطابقة'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Let is create an account for you',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(
              height: 50,
            ),
            MyTextFiled(
              hinText: 'Email',
              obscureText: false,
              controller: _emailcontroller,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFiled(
              hinText: 'Password',
              obscureText: true,
              controller: _passwordcontroller,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFiled(
              hinText: 'Confirm Password',
              obscureText: true,
              controller: _confirmpasswordcontroller,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already hane an account? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
