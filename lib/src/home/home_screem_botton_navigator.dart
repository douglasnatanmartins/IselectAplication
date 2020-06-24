import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/componentes/custom_drawer/custom_drawer.dart';
import 'package:iselectaplication1990/src/screems/s/favoritos.dart';
import 'package:iselectaplication1990/src/screems/s/perfil_screem.dart';

import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/config/page_profile.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/home/home_screem_page.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.orange,
              title: Text(
                "Servicios",
                style: GoogleFonts.amaranth(
                    textStyle: TextStyle(color: Colors.black, fontSize: 22)),
              )),
          body: HomeScreemPage(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange,
            title: Text(
              "Mis Favoritos",
              style: GoogleFonts.amaranth(color: Colors.black, fontSize: 22),
            ),
          ),
          body: Favoritos(),
          drawer: CustomDrawer(
            _pageController,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.orange[700],
            elevation: 0.0,
          ),
          body: PageProfile(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
          ),
          body: PerfilScreem(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
/*
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iselectaplication1990/src/screems/s/favoritos.dart';
import 'package:iselectaplication1990/src/screems/s/perfil_screem.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/home/home_screem_page.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/config/page_profile.dart';

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
}*/
