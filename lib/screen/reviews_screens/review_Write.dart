import 'dart:async';
import 'dart:io';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/review_main.dart';
import 'package:tong_myung_hotel/widgets/custom-widget-tabs.widget.dart';
import 'package:video_player/video_player.dart';

class ReviewWrite extends StatefulWidget {
  @override
  _ReviewWriteState createState() => _ReviewWriteState();
}

class _ReviewWriteState extends State<ReviewWrite> {
  String _uid;
  String _name; // auth 이름
  String _fieldName; // Users의 필드 항목에서 이름
  String _password;
  String _checkIn;
  String _checkOut;
  String _people;
  String _email;
  String _phone;
  String _book; // 방 유형 숫자
  String _imageUrl; // 방 사진 url
  String _roomName = '예약한 내역이 없습니다.'; // 방 이름
  String _writeDate;
  String _note;
  int reviewDoc = 1;
  double _starRate;
  File _image;
  File _image2;
  File _image3;
  var imageName;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  VideoPlayerController _toBeDisposed;
  String _retrieveDataError;
  final textEditingController = TextEditingController();
  Color green1 = Color.fromRGBO(133, 192, 64, 100);
  Color green2 = Color.fromRGBO(57, 103, 66, 10);
  TextEditingController _reviewController = TextEditingController();

  bool _isUploading = false;
  bool _isUploadCompleted = false;

  double _uploadProgress = 0;

  // firebase

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  uploadImage() async {
    try {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0;
      });

      FirebaseUser user = await _auth.currentUser();

      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          basename(_image.path);

      final StorageReference storageReference =
          _storage.ref().child("Review_Image").child(user.uid).child(fileName);

      final StorageUploadTask uploadTask = storageReference.putFile(_image);

      final StreamSubscription<StorageTaskEvent> streamSubscription =
          uploadTask.events.listen((event) {
        var totalBytes = event.snapshot.totalByteCount;
        var transferred = event.snapshot.bytesTransferred;

        double progress = ((transferred * 100) / totalBytes) / 100;
        setState(() {
          _uploadProgress = progress;
        });
      });

      StorageTaskSnapshot onComplete = await uploadTask.onComplete;

      String photoUrl = await onComplete.ref.getDownloadURL();

      _db.collection("Reviews").add({
        "photoUrl": photoUrl,
        "name": user.displayName,
        "caption": textEditingController.text,
        "date": DateTime.now(),
        "uid": user.uid,
        "starRate": _starRate,
        'roomType': _roomName,
      });

      // when completed
      setState(() {
        _isUploading = false;
        _isUploadCompleted = true;
      });

      streamSubscription.cancel();
      Navigator.pop(this.context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var ratio = (height + width) / 2;
    String dropdownValue;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 15),
        child: AppBar(
          title: Row(children: [
            SizedBox(
              width: width / 5,
            ),
            Text(
              '후기작성하기',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NanumSquareB',
                  fontSize: ratio / 30),
              textAlign: TextAlign.center,
            )
          ]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.black, size: ratio / 30),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            _uid = snapshot.data.uid;
            _name = snapshot.data.displayName;
            _email = snapshot.data.email;

            Firestore.instance
                .collection('Users')
                .document(_uid)
                .get()
                .then((DocumentSnapshot ds) {
              _uid = snapshot.data.uid;
              _name = snapshot.data.displayName;
              _email = snapshot.data.email;
              _roomName = ds.data['방 유형후기'];
              _checkIn = ds.data['입실일후기'];
              _checkOut = ds.data['퇴실일후기'];
              _people = ds.data['인원후기'];

              if (_roomName == '1' ||
                  _roomName == '2' ||
                  _roomName == '7' ||
                  _roomName == '8') // 방 유형 번호에 따른 사진출력
                _imageUrl = 'gs://tu-domi.appspot.com/room_type/three_room.png';
              else if (_roomName == '3' ||
                  _roomName == '4' ||
                  _roomName == '9' ||
                  _roomName == '10')
                _imageUrl = 'gs://tu-domi.appspot.com/room_type/two_room.png';
              else if (_roomName == '5' || _roomName == '6')
                _imageUrl = 'gs://tu-domi.appspot.com/room_type/four_room.png';

              switch (_roomName) {
                // 방 유형 번호에 따른 방 이름 지정
                case '1':
                  _book = '남성 3인 도미토리';
                  break;
                case '2':
                  _book = '남성 3인실';
                  break;
                case '3':
                  _book = '남성 2인 도미토리';
                  break;
                case '4':
                  _book = '남성 2인실';
                  break;
                case '5':
                  _book = '여성 4인 도미토리';
                  break;
                case '6':
                  _book = '여성 4인실';
                  break;
                case '7':
                  _book = '여성 3인 도미토리';
                  break;
                case '8':
                  _book = '여성 3인실';
                  break;
                case '9':
                  _book = '여성 2인 도미토리';
                  break;
                case '10':
                  _book = '여성 2인실';
                  break;
              }
            });

//            Firestore.instance //현재 로그인 된 Uid의 Users 문서의 필드 값을 가져옴
//                .collection('Reviews')
//                .document(_uid)
//                .get()
//                .then((DocumentSnapshot ds) {
//              _imageUrl = ds.data['ImageUrl'];
//              _writeDate = ds.data['date'];
//              _name = ds.data['name'];
//              _starRate = ds.data['starRate'];
//              _uid = ds.data['uid'];
//              //_roomName = ds.data['방유형'];
//              _note = ds.data['note'];
//            });
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    SizedBox(
                      height: height / 50,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 1),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('이용내역',
                                  style: TextStyle(
                                      fontFamily: 'NanumSquareB',
                                      fontSize: ratio / 30)),
                              SizedBox(
                                height: height / 40,
                              ),
                              Row(children: [
                                Icon(Icons.calendar_today),
                                Text(
                                  '  ' + _checkIn + ' ~ ' + _checkOut,
                                  style: TextStyle(
                                      fontFamily: 'NanumSquareB',
                                      fontSize: ratio / 36),
                                ),
                              ]),
                              Row(children: [
                                Container(
                                  width: width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      width: width / 5,
                                      height: height / 5,
                                      placeholder: AssetImage(
                                          "assets/images/placeholder.png"),
                                      image: FirebaseImage(_imageUrl),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _book,
                                      style: TextStyle(
                                          fontFamily: 'NanumSquareB',
                                          fontSize: ratio / 33),
                                    ),
                                    SizedBox(
                                      height: height / 100,
                                    ),
                                    Text(
                                      _people + '인',
                                      style: TextStyle(
                                          fontFamily: 'NanumSquareR',
                                          fontSize: ratio / 33),
                                    ),
                                    SizedBox(
                                      height: height / 50,
                                    ),
                                  ],
                                )
                              ]),
                            ])),
                    Divider(),
                    SizedBox(
                      height: height / 70,
                    ),

                    Text('별점',
                        style: TextStyle(
                            fontFamily: 'NanumSquareB', fontSize: ratio / 30)),
                    SizedBox(
                      height: height / 70,
                    ),
//                      SmoothStarRating(
//                        //rating: rating,
//                        color: Color.fromRGBO(233, 233, 233, 1),
//                        borderColor: Color.fromRGBO(233, 233, 233, 1),
//                        isReadOnly: false,
//                        size: 50,
//                        filledIconData: Icons.star,
//                        halfFilledIconData: Icons.star_half,
//                        defaultIconData: Icons.star,
//                        starCount: 5,
//                        allowHalfRating: true,
//                        spacing: 2.0,
//                        onRated: (value) {
//                          _starRate = value;
//                        },
//                      ),
                    RatingBar(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _starRate = rating;
                      },
                    ),
                    SizedBox(
                      height: height/40,
                    ),

                        Text('사진 첨부 (최대 3장)',style: TextStyle(
                            fontFamily: 'NanumSquareB',
                            fontSize: ratio / 30)),
                    SizedBox(
                      height: height / 70,
                    ),
//                        _image == null
//                            ? Text('No Image')
//                            : Image.file(
//                          _image,
//                          width: width / 3,
//                          height: height / 5,
//                        ),
                       Row(children:[_image == null ? Container(
                         width: width/4.5,
                         height: height/10,
                         decoration: BoxDecoration(
                           border: Border.all(
                             color: Color.fromRGBO(191, 191, 191, 1),
                           ),
                           borderRadius: BorderRadius.circular(5),
                           color: Color.fromRGBO(233, 233, 233, 1),
                         ),
                         child: FlatButton(
                          child: Icon(Icons.add_a_photo) ,
                          onPressed: () {
                            getImage(ImageSource.gallery, '1');
                          },
                        ),
                       ) : Image.file(_image, width: width/4.5,height: height/10,),
                       SizedBox(width: width/40,)
                       ,
                         _image2 == null ? Container(
                           width: width/4.5,
                           height: height/10,
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: Color.fromRGBO(191, 191, 191, 1),
                             ),
                             borderRadius: BorderRadius.circular(5),
                             color: Color.fromRGBO(233, 233, 233, 1),
                           ),
                           child: FlatButton(
                             child: Icon(Icons.add_a_photo) ,
                             onPressed: () {
                               getImage(ImageSource.gallery, '2');
                             },
                           ),
                         ) : Image.file(_image2, width: width/4.5,height: height/10,),
                         SizedBox(width: width/40,)
                         ,
                         _image3 == null ? Container(
                           width: width/4.5,
                           height: height/10,
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: Color.fromRGBO(191, 191, 191, 1),
                             ),
                             borderRadius: BorderRadius.circular(5),
                             color: Color.fromRGBO(233, 233, 233, 1),
                           ),
                           child: FlatButton(
                             child: Icon(Icons.add_a_photo) ,
                             onPressed: () {
                               getImage(ImageSource.gallery, '3');
                             },
                           ),
                         ) : Image.file(_image3, width: width/4.5,height: height/10,),
                       ]),
                    SizedBox(
                      height: height/40,
                    ),
                    Row(children: [
                      Text('후기작성',
                          style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              fontSize: ratio / 30)),
                      Text(' (5글자 이상 작성해주세요)',style: TextStyle(fontFamily: 'NanumSquareR',fontSize: ratio/30)),
                    ]),
                    SizedBox(
                      height: height/40,
                    ),
                    Container(
                        width: width / 1,
                        height: height/7,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: '   이용하신 숙소는 어떠셨나요?',
                            hintStyle: TextStyle(fontFamily: 'NanumSquareR',fontSize: height / 50),
//                          filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(28, 174, 129, 1)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(28, 174, 129, 1)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          controller: textEditingController,
                        )),

SizedBox(height: height/20,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: width/2.5,
                            height: height/18,
                            child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: Color.fromRGBO(56, 56, 56, 1),
                      )),
                      child: Text('취소',
                          style: TextStyle(fontFamily: 'NanumSquareB')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),),
                      Container(
                        width: width/2.5,
                        height: height/18,
                        child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Color.fromRGBO(28, 174, 129, 1),
                        child: Text(
                          '후기등록하기',
                          style: TextStyle(fontFamily: 'NanumSquareB',color: Colors.white),
                        ),
                        onPressed: () {
                          if (textEditingController.text.isNotEmpty &&
                              textEditingController.text.length > 4) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('작성하시겠습니까?'),
                                    actions: [
                                      FlatButton(
                                        child: Text('OK',
                                            style: TextStyle(color: green2)),
                                        onPressed: () async {
                                          if (_image != null)
                                            uploadImage();
                                          else if (_image == null) {
                                            FirebaseUser user =
                                                await _auth.currentUser();
                                            _db.collection("Reviews").add({
                                              "photoUrl":
                                                  'https://firebasestorage.googleapis.com/v0/b/tu-domi.appspot.com/o/Review_Image%2FH49QVtz9ixQe4hl35UEEJvgSviO2%2Fno-image.png?alt=media&token=313fc659-6990-4304-b61b-e01ff9a3abb3',
                                              "name": user.displayName,
                                              "caption":
                                                  textEditingController.text,
                                              "date": DateTime.now(),
                                              "uid": user.uid,
                                              "starRate": _starRate,
                                              "roomType": _roomName,
                                            });
                                          }

                                          Navigator.of(context).pop();
                                          // Navigator.of(context).pushReplacement(CustomWidgetExample(index: 1,));
                                          //  Navigator.pushNamedAndRemoveUntil(context, '/review', (route) => false);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Cancel',
                                            style: TextStyle(color: green2)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else if (textEditingController.text.length < 5) {
                            Fluttertoast.showToast(
                              msg: "후기를 5자 이상 입력하세요.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: green1,
                              textColor: Colors.white,
                              fontSize: height / 40,
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      child: Container(
                                    child: SingleChildScrollView(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          Text(
                                            '후기를 입력해주세요.',
                                            textAlign: TextAlign.center,
                                          ),
                                          Icon(Icons.border_color),
                                        ])),
                                  ));
                                });
                          }
                        },
                      ),),
                      SizedBox(
                        width: width / 15,
                      ),

                    ])
                  ],
                ),
              ),
            );
          } else {
            return Text('Loading...');
          }
        },
      ),
    );
  }

//  Widget roomName(){
//    if(_book == '0')
//      return Text('예약 정보가 없습니다.');
//    else
//      return Text(_roomName);
//  }

  Widget showImage() {
    if (_image == null)
      return Container();
    else
      return Image.file(_image);
  }

  Future getImage(ImageSource imageSource, String img) async {
    File image = await ImagePicker.pickImage(source: imageSource);
    imageName = image.uri;
    setState(() {
      switch(img)
      {
        case '1' :
            _image = image;
        break;
        case '2' :
          _image2 = image;
          break;
        case '3':
          _image3 = image;
      }
    });
  }
}
