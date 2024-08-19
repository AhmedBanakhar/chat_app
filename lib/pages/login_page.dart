// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/Services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfiled.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, this.onTap});

  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  void login(BuildContext context) async {
    final auth = AuthService();

    //? تحقق من أن المدخلات ليست فارغة
    if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('خطأ'),
          content: const Text(
              'لايمكن ترك الايميل وكلمه المرور فاضيه'), // عرض رسالة الخطأ هنا
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
              },
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    } else {
      try {
        await auth.signInWithEmailPassword(
            _emailcontroller.text, _passwordcontroller.text);

        //? إذا تم تسجيل الدخول بنجاح، يمكنك متابعة العملية
        //StepState({}); // تأكد من استخدام StepState بشكل صحيح
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
    }

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('خطأ'),
    //     content: Text(errorMessage), // عرض رسالة الخطأ هنا
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop(); // إغلاق الحوار
    //         },
    //         child: Text('موافق'),
    //       ),
    //     ],
    //   ),
    // );
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
              'Welcom Back ,you have been missed!',
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
              height: 20,
            ),
            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
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
