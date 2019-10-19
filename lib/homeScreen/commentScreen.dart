import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({Key key}) : super(key: key);

  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  Widget _allComments = Container(
    padding: EdgeInsets.all(16.0),
    child: Center(child: CircularProgressIndicator(),),
  );

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Comment'),
        actions: [
          new FlatButton(
              onPressed: () {
                 Navigator
                    .of(context)
                    .pop();
              },
              child: new Text('CLOSE',
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    prefixIcon: Icon(Icons.add_comment),
                    labelText: "Add Comment."),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Add Comment"),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "All Comments",
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              ),
            ),
            _allComments,
            ListTile(
              title: Text("asdasd"),
              subtitle: Text("saodijoadjoasjdasdapiosjdoj"),
              leading: Icon(
                Icons.account_circle,
                size: 35.0,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
