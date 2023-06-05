import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyles_test_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/first_screen.dart';
import 'screens/second_screen.dart';
import 'screens/third_screen.dart';
import 'screens/fourth_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(
            color: Colors.white, // Set the color of the title text
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.indigo,
          selectedItemColor: Colors.white,
        ).copyWith(
          unselectedItemColor: Colors.white.withOpacity(0.6),
        ),
      ),
      home: const MyHomePage(title: 'Animal Ranker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final User? user = Auth().currentUser;

  static final List<Widget> _widgetOptions = <Widget>[
    FirstScreen(),
    SecondScreen(),
    ThirdScreen(),
    FourthScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: _signOut, child: const Text('Sign Out'));
  }

  Future<void> _signOut() async {
    await Auth().signOut();
    // Add any additional sign out logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _signOutButton(),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.indigo,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'First',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Second',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Third',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Fourth',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
