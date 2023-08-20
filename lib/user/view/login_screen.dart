import 'dart:convert';
import 'dart:io';

import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    final dio = Dio();



    return DefaultLayout(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            top: true,
            // bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Title(),
                  const SizedBox(height: 16.0,),
                  _SubTitle(),
                  Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width /3 * 2,
                  ),
                  CustomTextFormField(
                    hintText: '이메일을 입력해주세요.',
                    onChanged: (String value) {
                      print(value);
                      this.username = value;
                    },
                  ),
                  const SizedBox(height: 16.0,),
                  CustomTextFormField(
                    hintText: '비밀번호를 입력해주세요.',
                    obscureText: true,
                    onChanged: (String value) {
                      this.password = value;
                    },
                  ),
                  const SizedBox(height: 16.0,),
                  ElevatedButton(
                    onPressed: () async {
                      // ID:비밀번호
                      // final rawString = 'test@codefactory.ai:testtest';
                      final rawString = '${this.username}:${this.password}';
                      print(rawString);

                      Codec<String, String> stringToBase64 = utf8.fuse(base64);

                      String token = stringToBase64.encode(rawString);

                      final resp = await dio.post(
                        'http://$ip/auth/login',
                        options: Options(
                          headers: {
                            'authorization': 'Basic $token',
                          }
                        )
                      );

                      final refreshToken = resp.data['refreshToken'];
                      final accessToken  = resp.data['accessToken' ];

                      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                      await storage.write(key: ACCESS_TOKEN_KEY , value: accessToken );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RootTab()
                        )
                      );

                      print(resp.data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: Text(
                      '로그인',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {

                    },
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Text(
                      '회원가입'
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요! \n 오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      )
    );
  }
}

