import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';


class Post {
  final int totalResults;
  final String status;
  int newsId;
  String title;
  String desc;
  Post({this.totalResults,this.status,this.desc,this.newsId,this.title});
}

void main() => runApp(Khabar());


class Khabar extends StatefulWidget {
  @override
  _KhabarState createState() => _KhabarState();
}

class _KhabarState extends State<Khabar> {
  List data;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      this.getJsonData();
    }
  
  Future<String> getJsonData() async{
    var response = await http.get(
      Uri.encodeFull("https://newsapi.org/v2/top-headlines?country=in&apiKey=08394049a09c45e2ac6253eadd754082"),
      headers: {"Accept": "application/json"}
    );
    setState(() {
       var convertDataToJson = json.decode(response.body);
       data = convertDataToJson['articles'];  
        });
        // print(data[3]["urlToImage"]);
        return "Success";
   
  }

  exitApp()
  {
    exit(0);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chota Khabari",
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Chota Khabari",style: TextStyle(color: Colors.black,fontSize: 30.0),),
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.exit_to_app,size: 30.0,),onPressed:exitApp,color: Colors.black,),
        ),
        body: new Container(
            child: RefreshIndicator(
              onRefresh: getJsonData,
              child:
                new ListView.builder(
                padding: EdgeInsets.all(10.0),
                addAutomaticKeepAlives: true,
                itemCount: data == null? 0:data.length,
                itemBuilder: (BuildContext context,int index)
                {
                  return InkWell(
                   borderRadius: BorderRadius.circular(20.0),
                    splashColor: Colors.red,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsPage(
                      title: data[index]["title"],
                      desc: data[index]["description"]==null?"Unable to load news":data[index]["description"],
                      url: data[index]["url"],
                      urlToImage: data[index]["urlToImage"],
                      date: data[index]["publishedAt"].toString().split("T")[0],
                      time: data[index]["publishedAt"].toString().split("T")[1].split("Z")[0],))),
                    child:new Card(
                      elevation: 8.0,
                      color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                         margin: EdgeInsets.only(top: 15.0,bottom: 15.0,left: 10.0,right:10.0 ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                               
                            CachedNetworkImage(
                             imageUrl: data[index]["urlToImage"]==null?"https://static.thenounproject.com/png/41260-200.png":data[index]["urlToImage"],
                              errorWidget: CircularProgressIndicator(),
                              width: double.infinity,
                                   ),
                              Padding(padding: EdgeInsets.only(top: 20.0),),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0,),
                                  child: Column(
                                  children: <Widget>[
                                    Text(data[index]["title"],style:TextStyle(fontSize: 20.0)),
                                    Padding(
                                      padding: EdgeInsets.only(top:30.0),
                                    )
                                  ],
                                ),
                                )
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0),),
                          ],
                        ),
                      ),
                  );
                },
          ),
            ),
        ),
      ),
    );
  }
}

class NewsPage extends StatefulWidget {
   
   final String title;
   final String desc;
   final String url;
   final String urlToImage;
   final String time;
   final String date;



  @override
  _NewsPageState createState() => _NewsPageState();
  NewsPage({Key key, this.date,this.title,this.desc,this.url,this.urlToImage,this.time}) : super(key: key);
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: "Chota Khabari",
     home: new Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
         centerTitle: true,
         title: Text("Chota Khabari",style: TextStyle(color: Colors.black,fontSize: 30.0)),
         backgroundColor: Colors.white,
         elevation: 0.0,
         leading: new IconButton(
           icon: Icon(Icons.arrow_back_ios,size: 35.0,color: Colors.black,),
           onPressed: ()=>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Khabar())),
         ),
       ),
       body: Column(
         children: <Widget>[
           Expanded(
         child:  ListView(
         shrinkWrap: true,
         children: <Widget>[
           Container(
         color: Colors.white,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top: 5.0),
             ),
              new CachedNetworkImage(
                  imageUrl:
                   "${widget.urlToImage}",
                   placeholder: CircularProgressIndicator(),
               ),
             
             Padding(
               padding: EdgeInsets.all(15.0),
             ),
             Card(
               elevation: 0.0,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10.0),
               ),
               
               margin: EdgeInsets.all(12.0),
               child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  "${widget.title}",style: TextStyle(color: Colors.grey[700],fontSize: 22.0,fontWeight: FontWeight.bold),
                ),
              Padding(
                  padding: EdgeInsets.only(top: 60.0),
                ),
                Text(
                  "${widget.desc}",style: TextStyle(color: Colors.grey[850],fontSize: 19.0),
                ),
              Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                
                Text(
                  "Published At: ${widget.time}",style: TextStyle(color: Colors.black,fontSize: 15.0
                  ),),
                 Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Text(
                  "Published On: ${widget.date}",style: TextStyle(color: Colors.black,fontSize: 15.0
                  ),
                ),

              ],
               ),
             )
           ],
         ),
       ),
       Container(
         padding: EdgeInsets.symmetric(horizontal: 15.0),
         child: RichText(
         text: TextSpan(
          text: '${widget.url}',
                  style: new TextStyle(color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      launch( '${widget.url}'
                          );
                    },
       
       ),
       ),
       ),
       Padding(
         padding: EdgeInsets.only(bottom: 20.0),
       )
         ],
       ),
       )
         ],
       )
     ),
    );
  }
}