import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/screen/sign_screens/login_screen.dart';
import 'package:tong_myung_hotel/screen/sign_screens/signup_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: width,
              height: height,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height/4.5,),
              Text('TMDT', style: TextStyle(fontFamily: 'HYShortSamul',fontSize: width/5),textAlign: TextAlign.center,),
              SizedBox(height: height/100,),
              Text('가족, 친구 그리고 혼자서 여행할 때', style: TextStyle(fontFamily: 'NanumSquareB',fontSize: width/24),),
              SizedBox(height: height/30,),
              Text('숙소 걱정말고 즐거운 여행 하세요!', style: TextStyle(fontFamily: 'NanumSquareR',fontSize: width/18),),
              SizedBox(height: height/3,),
              Container(
                height: height/12,
                width: width/1.3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: FlatButton(
                  //color: Colors.white,
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontFamily: 'NanumSquareEB',
                        fontSize: MediaQuery.of(context).size.width/19
                   ,color: Color.fromRGBO(28, 174, 129, 1)),
                  ),
//                  shape: OutlineInputBorder(
//                    borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 80)),
//                    borderRadius: BorderRadius.circular(60),
//                  ),
                  padding: const EdgeInsets.all(5),
                  textColor: Colors.white,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));

                  },
                ),
              ),
              SizedBox(height: height/35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('회원이 아니신가요?  ',style: TextStyle(
                    fontFamily: 'NanumSquareR',
                    fontSize: width/25,
                  )),
                  InkWell(
                    child: Text('회원가입',
                    style: TextStyle(
                        fontFamily: 'NanumSquareEB',
                        fontSize: width/25,
                      decoration: TextDecoration.underline
                    ),),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignupScreen()));

                    },
                  )

                ],
              )
            ],
          )),
        ),

    );
  }
}
