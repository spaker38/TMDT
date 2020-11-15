//사용자가 방을 예약하기위해 자신이 원하는 옵션을 고르는 기능을 할 수 있는 화면이다.

import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:tong_myung_hotel/CustomButtons/ButtonTextStyle.dart';
import 'package:tong_myung_hotel/CustomButtons/CustomRadioButton.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/model/bookingConditionSlide.dart';
import 'package:tong_myung_hotel/model/homeSlide.dart';
import 'package:tong_myung_hotel/screen/book_screens/booking_room.dart';
import 'package:tong_myung_hotel/widgets/bookingCondition_slide_dots.dart';
import 'package:tong_myung_hotel/widgets/bookingCondition_slide_item.dart';
import 'package:tong_myung_hotel/widgets/home_slide_dots.dart';

////PageController 를 사용하기위해 import 한 녀석들이다.////
import '../../widgets/slide_item.dart';
import '../../model/slide.dart';
import '../../widgets/slide_dots.dart';
////PageController 를 사용하기위해 import 한 녀석들이다.////

class Book_room_stful extends StatefulWidget {
  String type;

  Book_room_stful({
    this.type,
  });

  @override
  _Book_room_stfulState createState() => _Book_room_stfulState();
}

class _Book_room_stfulState extends State<Book_room_stful> {
  
  //edit this
  bool selected = true;
  //사용자가 설정하는 퇴실날짜 시간이다.
  DateTime _dateTime_exit_room_time;
  //사용자가 설정하는 입실날짜 시간이다.
  DateTime _dateTime_enter_room_time;

  ////////  체크박스의 남자와 여자를 체크하기위해 존재하는 변수이다.   ////////
  int _counter=0;
  var _isChecked=false;


  //고객이 설정한 성별이다.
  String gender;
  String _gender="Gender.MAN";

  Object get type => null;

  void _incrementCounter(){
    setState((){

      _counter++;

    });
  }
  ////////  체크박스의 남자와 여자를 체크하기위해 존재하는 변수이다.   ////////

  //방에 들어갈 인원수를 표현하기위한 코드들이다.
  //초기값
  String dropdownValue = '';
  int dropdownValue_Integer=1;

  /////////////////////   방유형을 표현하는 PageController 와 관련된 코드이다.  ////////////////////

  //최근 페이지를 의미한다.
  int _currentPage = 0;
  //스피너의 현재 페이지를 표현하기위한 변수다
  int now_page = 0;

  //PageController : A controller for [PageView].
  //내 생각 : 한장씩 바뀌는 페이지를 표현해주는 코드인듯 하다. 가장 첫페이지는 PageController의 생성자를 통해서 0으로 설정되있다.
  final PageController _pageController = PageController(initialPage: 0);

  /////////////////////   방유형을 표현하는 PageController 와 관련된 코드이다.  ////////////////////

  /////////////////////   Time Picker 기능(달력에서 시간설정하기) 기능을 사용하기위한 코드이다  ////////////////////
  String _selectedDate = '날짜 선택';
  //입실시간 UI 색깔이다.
  Color enter_time_Color = Color.fromARGB(225, 168, 168, 168);
  //퇴실시간 UI 색깔이다.
  Color exit_time_Color = Color.fromARGB(225, 168, 168, 168);

  /////////////////////   Time Picker 기능(달력에서 시간설정하기) 기능을 사용하기위한 코드이다  ////////////////////

  @override
  void initState() {
    super.initState();

    //한페이지가 얼만큼 머루를것인지 시간을 설정해주는 코드인듯 하다.
    //Timer : Creates a new repeating timer. (periodic : 반복되는)

    //"만약 5초의 시간이 흐른다면" 을 표현하는 코드인듯. 사진이 한번씩 바뀌는 시간주기이다.
    Timer.periodic(Duration(seconds: 50000), (Timer timer) {

      //animateToPage : Animates(만화영화로 만들다) the controlled [PageView] from the current page to the given page.
      _pageController.animateToPage(
        _currentPage,

        // The animation lasts for the given duration and follows the given curve.
        // 애니메이션이 주어진 시간동안 유지되고 주어진 curve에 따른다.
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  //페이지가 바뀔 때 마다 호출되는 메소드이다. 현재 몇번째 페인지 변수로 알 수 있다.
  _onPageChanged(int index) {
    setState(() {
      if(index==2){
        _currentPage=3;
        now_page=2;
        print("_currentPage1");
        print(_currentPage);
      }
      else{
        _currentPage = index;
        now_page=index;
        print("_currentPage2");
        print(_currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    double ratio = (wi+hi)/2;

    //핸드폰 전체크기의 비율값
    double width=getWidthRatio(360,context);
    double height=getHeightRatio(640,context);

    double phone_avg=(width+height)/2;

    //사용자가 묶을 방의형태에 따라 인원수를 설정하는 스피너는 보일 수 도 있고 안보일 수 도 있다. 스피너유무를 설정해주는 변수이다.
    var spinner_condition;

    if(Variable.sleep_type=="Hotel"){
      spinner_condition=false;
      Count_Hotel();
    }
    else if(Variable.sleep_type=="Guest_House"){
      spinner_condition=true;
    }

    //사용자가 입력한 입실날짜와 퇴실날짜의 차이를 표현하는 변수다.
    String time_differ;

    //사용자가 입력한 입실날짜와 퇴실날짜의 차이를 표현하는 변수다. (int 형)
    int time_differ_Integer;

    // 사용자가 몇일이나 묶는지 확인할 때 조건문에 필요한 변수
    int idx;
    String gap;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: ratio/30 ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('    예약하기', style: TextStyle(
          color: Colors.black,
          fontFamily: 'NanumSquareB',
        )),

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(

                children: <Widget>[

                  Positioned(
                    //top 과 left 가 존재하지 않는 이유는 Figma 에서 가져올 때 Group 형태로 가져오지 않고 Frame 그 자체로 가져왔기 떄문이다. 따라서 여백이 없다.

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        // Figma Flutter Generator Android1Widget - FRAME
                        Container(
                          width: 360*width,
                          height: 640*height,
                          decoration: BoxDecoration(
                            color : Color.fromRGBO(255, 255, 255, 1),
                          ),

                          child: Stack(
                            children: <Widget>[

                              //입실날짜 아래쪽에 "인원수" 를 표현하는 텍스트이다.
                              Positioned(
                                  top: 179*height,
                                  left: 15*width,
                                  child: Text('인원수', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //"(최대 4인까지 가능)" 텍스트를 표현한다
                              Positioned(
                                  top: 180*height,
                                  left: 55*width,
                                  child: Text('(최대 4인까지 가능)', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/32,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //"방의유형" 텍스트를 표현한다.
                              Positioned(
                                  top: 257*height,
                                  left: 15*width,
                                  child: Text('방의 유형', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //"성별" 텍스트를 표현한다.
                              Positioned(
                                  top: 10*height,
                                  left: 15*width,
                                  child: Text('성별', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              Positioned(
                                  top: 101*height,
                                  left: 15*width,
                                  child: Text('입실날짜                                   퇴실날짜', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //입실날짜와 퇴실날짜 텍스트 바로아래의 타원형 도형이다.
                              Positioned(
                                  top: 120*height,
                                  left: 14*width,
                                child: Container(
                                  height: 50*width,
                                  width: 280*height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(225, 168, 168, 168),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              //입실날짜와 퇴실날짜 텍스트 바로아래의 타원형 사이의 중간선을 의미한다 top 과 left에 width 와 height 값을 서로 반대로 적었는데 결과가 제대로나와서 걍 내비둠.
                              Positioned(
                                top: 120*height,
                                left: 28*width,
                                child: Container(
                                  height: 50*width,
                                  width: 125*height,
                                  decoration: BoxDecoration(
                                   border: Border(
                                     right: BorderSide(
                                       color: Color.fromARGB(225, 168, 168, 168),
                                       width:1*width,
                                     ),
                                   )
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                          //성별선택에서 남자 라디오버튼
                          Positioned(
                              top: 45*height,
                              left: 28*width,
                              child:
                                  Container(
                                    padding: EdgeInsets.all(3.5),
                                    child: CustomRadioButton(
//                                      customShape: RoundedRectangleBorder(
//                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0)),
//                                          side: BorderSide(color: Colors.red)
//                                      ),

                                      enableShape: false,       //커스텀한 버튼의 모양이 만약 true인 경우 적용된다.
                                      elevation: 0,              //명암을 설정한다.
                                      defaultSelected: "Man",
                                      enableButtonWrap: true,   //This will enable button wrap (will work only if orientation is vertical)
                                      width: 147*width,
                                      height: 50*width,
                                      autoWidth: false,           //수직모드일때만 적용된다. 요구되는 최소한의 공간을 사용한다. 만약 이 기능이 가능하다면 width 기능을 무시한다.
                                      absoluteZeroSpacing: true,  //공간사이에 아예 공간이 없음을 표현하다.
                                      unSelectedColor: Theme.of(context).canvasColor,
                                      buttonLables: [
                                        "남자",
                                        "여자",
                                      ],
                                      buttonValues: [
                                        "Man",
                                        "Woman",
                                      ],
                                      radioButtonValue: (value) {
                                        print(value);

                                        if(value=="Man"){
                                          print("남자인경우");
                                          _gender="Gender.MAN";
                                        }
                                        else if(value=="Woman"){
                                          print("여자인경우");
                                          _gender="Gender.WOMEN";
                                          //check point
                                        }

                                      },
                                      //buttonTextStyle: ButtonTextStyle(),
                                      //selectedColor: Theme.of(context).accentColor,
                                      //selectedColor:Color.fromARGB(225, 102, 221, 170),
                                      selectedColor:Color.fromARGB(225, 28, 174, 129),

                                      //selectedBorderColor: Color.fromARGB(225, 0, 0, 0),
                                      //unSelectedBorderColor: Color.fromARGB(225, 0, 0, 0),

                                    ),

                                    decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white),
                                                  color: Color.fromARGB(225, 168, 168, 168),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(12),
                                                      bottomRight: Radius.circular(12),
                                                      topLeft: Radius.circular(12),
                                                      topRight:Radius.circular(12),

                                    ),

//                                      border: Border.all(
//                                          width: 1.0
//                                      ),
//
//                                      borderRadius: BorderRadius.all(
//                                          Radius.circular(15.0) //                 <--- border radius here
//                                      ),
                                      //borderRadius:BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0)),
                                    ),

                                  ),

                          ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                              Positioned(
                                top: 145*height,
                                left: 220*width,

                                child: Container(
                                  width: 120*width,
                                  height: 36*height,

                                ),
                              ),

                              //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                              Positioned(
                                top: 123*height,
                                left: -14*width,

                                child: Container(
                                    width: 120*width,
                                    height: 36*height,

                                    //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                    child: IconButton(
                                      icon: Icon(Icons.calendar_today, color: enter_time_Color),
                                      onPressed: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: _dateTime_enter_room_time == null ? DateTime.now() : _dateTime_enter_room_time,


                                            //달력내에서 선택할 수 있는 첫 년도이다.
                                            firstDate: DateTime(2020),

                                            //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                            lastDate: DateTime(2024)
                                        ).then((date){
                                          setState((){
                                            _dateTime_enter_room_time=date;
                                            _selectedDate=_dateTime_enter_room_time.toString();
                                            print("입실날짜 "+_dateTime_enter_room_time.toString());

                                          });
                                        });

                                        //입실날짜를 사용자가 선택하는경우 달력과 설정한 시간을 표현하는 텍스트의 색깔을 변경시켜준다.
                                        print(_selectedDate);
                                        enter_time_Color = Color.fromARGB(225,56,56,56);

                                      },  //onPressed end
                                    ),
                                ),
                              ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (입실시간 날짜)
                              Positioned(
                                top: 134*height,
                                left: 64*width,
                                child: Container(
                                  width: 120*width,
                                  height: 36*height,

                                    //사용자가 선택한 날짜를 띄워주는 Text
                                  child : InkWell(
                                    child:Text(_dateTime_enter_room_time == null ? '입실 날짜 선택' : _dateTime_enter_room_time.toString().substring(0,10),
                                      style: TextStyle(
                                        color: enter_time_Color,
                                        fontFamily: 'NanumSquareB',
                                      ),
                                    ),
                                    onTap: (){
                                      //사용자가 입실날짜를 설정하기위한 버튼을 누르면 버튼의 색을 수정시킨다.
                                      enter_time_Color = Color.fromARGB(225,56,56,56);
                                      showDatePicker(
                                          context: context,
                                          initialDate: _dateTime_enter_room_time == null ? DateTime.now() : _dateTime_enter_room_time,

                                          //달력내에서 선택할 수 있는 첫 년도이다.
                                          firstDate: DateTime(2020),

                                          //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                          lastDate: DateTime(2024)
                                      ).then((date){
                                        setState((){
                                          _dateTime_enter_room_time=date;
                                          _selectedDate=_dateTime_enter_room_time.toString();
                                          print("입실날짜 "+_dateTime_enter_room_time.toString());

                                          //만약 사용자가 날짜를 선택하지않고 취소를 한다면 다시 회색으로 달력및 글을 출력한다.
                                          if(date==null){
                                            enter_time_Color = Color.fromARGB(225, 168, 168, 168);
                                          }
                                        });
                                      });
                                    },    //onTap end
                                  )

                                ),
                              ),

                              //사용자가 퇴실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                              Positioned(
                                top: 123*height,
                                left: 144*width,

                                child: Container(
                                  width: 120*width,
                                  height: 36*height,

                                  //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                  child: IconButton(
                                    icon: Icon(Icons.calendar_today, color: exit_time_Color),
                                    onPressed: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: _dateTime_exit_room_time == null ? DateTime.now() : _dateTime_exit_room_time,

                                          //달력내에서 선택할 수 있는 첫 년도이다.
                                          firstDate: DateTime(2020),

                                          //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                          lastDate: DateTime(2024)
                                      ).then((date){
                                        setState((){
                                          _dateTime_exit_room_time=date;
                                          _selectedDate=_dateTime_exit_room_time.toString();
                                          print("퇴실날짜 "+_dateTime_exit_room_time.toString());

                                        });
                                      });

                                      //입실날짜를 사용자가 선택하는경우 달력과 설정한 시간을 표현하는 텍스트의 색깔을 변경시켜준다.
                                      print(_selectedDate);
                                      enter_time_Color = Color.fromARGB(225,56,56,56);

                                    },  //onPressed end
                                  ),
                                ),
                              ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                              Positioned(
                                top: 134*height,
                                left: 224*width,
                                child: Container(
                                    width: 120*width,
                                    height: 36*height,

                                    //사용자가 선택한 날짜를 띄워주는 Text
                                    child : InkWell(
                                      child:Text(_dateTime_exit_room_time == null ? '퇴실 날짜 선택' : _dateTime_exit_room_time.toString().substring(0,10),
                                        style: TextStyle(
                                          color: enter_time_Color,
                                          fontFamily: 'NanumSquareB',
                                        ),
                                      ),
                                      onTap: (){
                                        //사용자가 입실날짜를 설정하기위한 버튼을 누르면 버튼의 색을 수정시킨다.
                                        exit_time_Color = Color.fromARGB(225,56,56,56);
                                        showDatePicker(
                                            context: context,
                                            initialDate: _dateTime_exit_room_time == null ? DateTime.now() : _dateTime_exit_room_time,

                                            //달력내에서 선택할 수 있는 첫 년도이다.
                                            firstDate: DateTime(2020),

                                            //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                            lastDate: DateTime(2024)
                                        ).then((date){
                                          setState((){
                                            _dateTime_exit_room_time=date;
                                            _selectedDate=_dateTime_exit_room_time.toString();
                                            print("톼실날짜 "+_dateTime_exit_room_time.toString());

                                            //만약 사용자가 날짜를 선택하지않고 취소를 한다면 다시 회색으로 달력및 글을 출력한다.
                                            if(date==null){
                                              exit_time_Color = Color.fromARGB(225, 168, 168, 168);
                                            }
                                          });
                                        });
                                      },    //onTap end
                                    )

                                ),
                              ),


                              //'인원수' 글자 밑에 있는 회색 타원형박스
                              Positioned(
                                top: 200*height,
                                left: 14*width,
                                child: Container(
                                  height: 50*width,
                                  width: 280*height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(225, 168, 168, 168),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              // - 버튼을 표현한다.
                              Positioned(
                                  top: 203*height,
                                  left: -8*width,
                                  //사용자가 호텔식, 게스트하우스식 무엇을 선택하냐에 따라서 보여지는 UI가 다르다.
                                  child: spinner_condition == true ? new

                                  //사용자가 게스트하우스식을 선택한다면 드랍다운버튼이 표현되는 UI를 보여준다.
                                  Container(
                                    width: 110*width,
                                    height: 39*height,

                                    //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle_outline, color: Color.fromARGB(225, 28, 174, 129),),
                                      onPressed: Count_people_minus,
                                    ),
                                  )

                                  //수정전의 드롭다운버튼 코드
//                                    child: DropdownButton<String>(
//
//                                      value: dropdownValue,
//                                      icon: Icon(Icons.arrow_drop_down),
//                                      iconSize: 24,
//                                      elevation: 16,
//                                      style: TextStyle(color: Colors.black, fontSize: 18),
//                                      underline: Container(
//                                        height: 2,
//                                        color: Colors.blueAccent,
//                                      ),
//                                      onChanged: (String data) {
//                                        setState(() {
//                                          dropdownValue = data;
//                                        });
//                                      },
//                                      items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
//                                        //만약 사용자가 게스트하우스식을 선택했다면 인원수를 설정할 수 있는 UI가 보인다.
//                                        if(Variable.sleep_type=="Guest_House"){
//                                        }
//                                        //만약 사용자가 호텔식을 선택했다면 인원수를 설정할 수 있는 UI가 보이지 않는다.
//                                        else{
//
//                                        }
//                                        return DropdownMenuItem<String>(
//                                          value: value,
//                                          child: Text(value),
//                                        );
//                                      }).toList(),
//                                    ),
                                  //만약 사용자가 호텔식을 선택했다면 드롭다운 버튼의 UI 는 보이지 않는다.
                                      : new Container(

                                  )
                              ),

                              // + 버튼을 표현한다.
                              Positioned(
                                  top: 203*height,
                                  left: 250*width,
                                  //사용자가 호텔식, 게스트하우스식 무엇을 선택하냐에 따라서 보여지는 UI가 다르다.
                                  child: spinner_condition == true ? new

                                  //사용자가 게스트하우스식을 선택한다면 드랍다운버튼이 표현되는 UI를 보여준다.
                                  Container(
                                    width: 110*width,
                                    height: 39*height,

                                    //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle_outline, color: Color.fromARGB(225, 28, 174, 129),),
                                      onPressed: Count_people_plus,
                                    ),
                                  )
                                  //만약 사용자가 호텔식을 선택했다면 드롭다운 버튼의 UI 는 보이지 않는다.
                                      : new Container(

                                  )
                              ),

                              //드롭다운버튼 사이에서 사용자가 설정한 인원수를 표현하는 숫자다
                              Positioned(
                                top: 214*height,
                                left: 160*width,
                                child:Container(
                                  child: Text(
                                    //dropdownValue.substring(0,1),
                                    '$dropdownValue_Integer',
                                    style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'NanumSquareB',
                                    fontSize: MediaQuery.of(context).size.width/18,
                                  ),
                                  ),
                                )


                              ),

                              //방의유형을 표현하는 PageController 이다.
                              Positioned(
                                top: 290*height,
                                left: 14*width,
                                child: SingleChildScrollView(
                                    child: Container(
                                      width: 333*width,
                                      height: 200*height,

                                      child: Expanded(
                                        child: Stack(
                                          alignment: AlignmentDirectional.bottomCenter,
                                          children: <Widget>[

                                            //check point
                                            //방의 유형을 판별해주는 조건문이다.
                                            _gender.toString() == "Gender.MAN" ?

                                            //움직이는 페이지를 표현한다. (남자 손님들이 봐야하는 페이지)
                                            new PageView.builder(
                                              scrollDirection: Axis.horizontal,
                                              controller: _pageController,
                                              onPageChanged: _onPageChanged,

                                              itemCount: man_type.length,
                                              //itemCount: woman_type.length,
                                              itemBuilder: (ctx, i) => BookingCondition_slide_item(i),
                                            ) :

                                            //움직이는 페이지를 표현한다. (여자 손님들이 봐야하는 페이지)
                                            new PageView.builder(
                                              scrollDirection: Axis.horizontal,
                                              controller: _pageController,
                                              onPageChanged: _onPageChanged,

                                              //itemCount: woman_type.length,
                                              itemCount: slideList_room_condition.length,
                                              //itemCount: man_type.length,
                                              itemBuilder: (ctx, i) => BookingCondition_slide_item(i),
                                            ),

                                            Stack(
                                              alignment: AlignmentDirectional.topStart,
                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Column(
//                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                                                  children: <Widget>[
//                                                  ],
//                                                )

                                            Container(
                                            margin: const EdgeInsets.only(bottom: 3),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                          for(int i = 0; i<slideList_room_condition.length; i++)
                                          if( i == now_page )
                                        BookingConditionSlideDots(true)
                                    else
                                    BookingConditionSlideDots(false)
                                ],
                              ),
                        )

                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                    )),
                              ),

                              Positioned(
                                top: 540*height,
                                left: 230*width,
                                child:
                                RaisedButton(
                                    child: Text('검색하기', style: TextStyle(fontSize: 24)),
                                    onPressed: () =>
                                    {
                                    time_differ=_dateTime_exit_room_time.difference(_dateTime_enter_room_time).toString(),
                                    print(time_differ),
                                    idx = time_differ.indexOf(":"),
                                    gap = time_differ.substring(0, idx),
                                    time_differ_Integer=int.parse(gap),
                                    time_differ_Integer=time_differ_Integer~/24,
                                    print("퇴실일과 입실일의 차이"),
                                    print(time_differ_Integer),
                                    dropdownValue=dropdownValue_Integer.toString()+'명',
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>
                                          Booking_room(

                                              search_condition: widget.type,
                                              guest_gender: _gender.toString(),
                                              exit_room_time: _dateTime_exit_room_time.toString().substring(0, 10),
                                              enter_room_time: _dateTime_enter_room_time.toString().substring(0, 10),
                                              room_type: _currentPage.toString(),
                                              supply: dropdownValue,
                                              time_differ: time_differ_Integer)),
                                    ),

                                    }

                                ),


                              ),

                            ],
                          ),
                        ),

                      ],
                    ),

                  )


                ],
              )


          ),

        ),),);
  }

  //인원수를 설정하는 메소드이다. (마이너스 버튼을 누른경우)
  void Count_people_minus() {
    setState(() {

      dropdownValue_Integer--;
      if(dropdownValue_Integer<=0){
        dropdownValue_Integer=0;
      }

    });
  }

  //인원수를 설정하는 메소드이다. (플러스 버튼을 누른경우)
  void Count_people_plus() {
    setState(() {

      dropdownValue_Integer++;
      if(dropdownValue_Integer>=4){
        dropdownValue_Integer=4;
      }
    });
  }

  //만약 사용자가 호텔식을 설정했다면 인원수는 디폴트로 4로 설정한다.
  void Count_Hotel(){
    dropdownValue_Integer=4;
  }

}

