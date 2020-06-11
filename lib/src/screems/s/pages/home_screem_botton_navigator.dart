import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iselectaplication1990/src/home_screem_page.dart';
import 'package:iselectaplication1990/src/screems/s/config/page_profile.dart';
import 'package:iselectaplication1990/src/screems/s/config/perfil_screem.dart';
import 'package:iselectaplication1990/src/screems/s/favoritos.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  List Telas = [

    HomeScreemPage(),
    Favoritos(),
    PageProfile(),
    PerfilScreem(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: CurvedNavigationBar(
            index: _page,
            color: Colors.orange[500],
            backgroundColor: Colors.white,
            buttonBackgroundColor: Colors.orange[600],
            height: 55,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 18,
                color: Colors.black,
              ),
              Icon(
                Icons.favorite,
                size: 18,
                color: Colors.black,
              ),
              Icon(
                Icons.person,
                size: 18,
                color: Colors.black,
              ),
              Icon(
                Icons.settings,
                size: 18,
                color: Colors.black,
              )
            ],
            animationDuration: Duration(milliseconds: 200),
            animationCurve: Curves.easeInSine,
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          body: Telas[_page]
          /*Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black,
              primaryColor: Colors.red,
              textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.deepPurple),
              )
            ),
            child: BottomNavigationBar(
              currentIndex: _page,
              selectedItemColor: Colors.orange[900],
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  title: Text(
                    "Home",
                    style: GoogleFonts.amaranth(
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                  icon: Icon(
                    Icons.home,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    "Servicios",
                    style: GoogleFonts.amaranth(
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                  icon: Icon(
                    Icons.format_list_bulleted,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    "Perfil",
                    style: GoogleFonts.amaranth(
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                  icon: Icon(
                    Icons.person,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    "Configuraciones",
                    style: GoogleFonts.amaranth(
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                  icon: Icon(
                    Icons.settings,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ],
              onTap: (pagina){
                _pageController.animateToPage(pagina,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInSine
                );
              },
            ),
          ),*/


        /*PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _page = page;
            });
          },
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
            PageProfile(),
            Container(
              color: Colors.black54,
            ),
          ],
        ),*/
      ),
    );
  }
}