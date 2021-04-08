import 'package:flutter/material.dart';
import 'package:state_container/state_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum PageState {
  first,
  second,
  third,
}

class _MyHomePageState extends State<MyHomePage> {
  var _state = PageState.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StateContainer(
        state: _state,
        animationType: StateAnimationType.AXIS_HORIZONTAL,
        stateDefinitions: [
          StateDefinition(
            state: PageState.first,
            order: 0,
            builder: (context) => _firstState(),
          ),
          StateDefinition(
            state: PageState.second,
            order: 1,
            builder: (context) => _secondState(),
          ),
          StateDefinition(
            state: PageState.third,
            order: 2,
            builder: (context) => _thirdState(),
          ),
        ],
      ),
    );
  }

  Widget _firstState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is first state'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _state = PageState.second;
              });
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _secondState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is second state'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _state = PageState.first;
                  });
                },
                child: Text('Prev'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _state = PageState.third;
                  });
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thirdState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is third state'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _state = PageState.second;
              });
            },
            child: Text('Prev'),
          ),
        ],
      ),
    );
  }
}
