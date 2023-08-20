import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/view/splash_screen.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(_App());
}

// _를 넣는 이유는 private한 걸 선언할때 씀
class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 최상위에는 MaterialApp이 있어야함.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      // home: LoginScreen()
      home: SplashScreen(),
    );
  }
}
