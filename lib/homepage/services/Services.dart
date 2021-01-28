import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firstapp/homepage/model/fakemodel.dart';
import 'package:flutter/material.dart';

class Services with ChangeNotifier{

  List<Datas> _listData =[];

  List<Datas> get listData=> _listData;

   void setText(value,int index){
     _listData[index].title = value;
    notifyListeners();
  }
  void clear(int index){
     _listData[index].title = "";
     notifyListeners();
  }

  void setId(int index){
    _listData[index].id++;
     notifyListeners();
  }



  Services (){
    getApi();
  }

  getApi() async{
    String url = "https://jsonplaceholder.typicode.com/posts";
       Dio dio = new Dio();
       Response response ;
       FakeApi fakeApi;
       try{
         response = await dio.get(url);
         if(response.statusCode==200){
           final parse = json.decode('{"datas":${jsonEncode(response.data)}}');
           fakeApi = FakeApi.fromJson(parse);
           _listData.addAll(fakeApi.datas);
           notifyListeners();
         }
         else{
           print(response.statusCode);
           throw Exception('Unable to fetch data');
         }
       }catch(e){
         print(e);
       }
  }

}
