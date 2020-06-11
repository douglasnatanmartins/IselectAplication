import 'package:flutter/material.dart';
import 'package:iselectaplication1990/model/user_model.dart';
import 'package:iselectaplication1990/src/splash_screem.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                // primarySwatch: Colors.black,
                primaryColor: Colors.orange,
                accentColor:Colors.orange[700],
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home:SplashScreem()
          );
        },
      ),
    );
  }
}


/// Criar tela de privacidade no cadastro de usuario Listando os Campos
/// Verificar uma forma de conseguir criar um percential para as qualificacoes dos servicos.
/// Criar uma tela para editar o Servico e nao somente Apagalo.