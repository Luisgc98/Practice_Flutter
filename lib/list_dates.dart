import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Map> users = [
    {
      'nombre':'luis.gurrola',
      'edad':22,
      'email':'luis.gurrola.condor@gmail'
    },
    {
      'nombre':'yeick.puto',
      'edad':50,
      'email':'manuel.aguilar.condor@gmail.com'
    },
    {
      'nombre':'DonPendejo',
      'edad':'vegete',
      'email': null
    }
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('El Yeick es puto')
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index){
          var user = users[index];
          return UserDate(user=user);
        },
      ),
      
    );
  }
}

class UserDate extends StatelessWidget {
  var user;
  UserDate(this.user);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Nombre: ${user['nombre']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edad: ${user['edad']}',
          ),
          Text(
            user['email'] != null ? 'Email: ${user['email']}' : 'Sin datos',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        maxRadius: 25,
        child: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.info,
        color: Colors.black,
        size: 30,
      ),
    );
  }
}