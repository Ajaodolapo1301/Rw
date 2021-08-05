
import 'package:flutter/material.dart';
import 'package:rex_money/screens/home.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewContainer extends StatefulWidget {
  final url;
  WebViewContainer(this.url);
  @override
  createState() => _WebViewContainerState(this.url);
}
class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  _WebViewContainerState(this._url);
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
        appBar: AppBar(

          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black,),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
          },),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
                  margin: EdgeInsets.all(30),
                  child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: _url),
                ))
          ],
        ));
  }
}