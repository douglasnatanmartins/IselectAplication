import 'package:flutter/material.dart';
import 'package:iselectaplication1990/model/user_model.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/login/login_screem.dart';
import 'package:iselectaplication1990/src/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.orange[100],
                Colors.white
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 16.0,
                      left: 0.0,
                      child: Text("ISELECT\nSERVICIOS",
                        style: GoogleFonts.amaranth(
                            fontSize: 34.0, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Olá, ${!model.isloggedIn() ? "" : model.userData["name"]}",
                                  style: GoogleFonts.amaranth(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  )
                                ),
                                GestureDetector(
                                  child: Text(
                                    !model.isloggedIn() ?
                                    "Entrar"
                                        : "${ model.userData["email"]}",
                                    style: GoogleFonts.amaranth(

                                    )
                                  ),
                                  onTap: (){
                                    if(!model.isloggedIn())
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=> LoginPage())
                                      );
                                    else
                                      model.signOut();
                                  },
                                )
                              ],
                            );
                          },
                        )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.favorite, "Favoritos", pageController, 1),
              DrawerTile(Icons.person, "Mi Perfil", pageController, 2),
              DrawerTile(Icons.settings, "Configuraciones", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
