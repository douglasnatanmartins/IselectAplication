import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SobreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.orange[400],
            Colors.orange[300],
            Colors.orange[200],
            Colors.white
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/encanador.jpg"),
                    scale: 1.0,
                    fit: BoxFit.cover
                  )
              ),
              child: Container(color: Colors.white.withAlpha(100),),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 27, ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 8,),
                Align(
                    alignment: Alignment.center,
                  child: Text(
                    "Iselect Servicios",
                    style: GoogleFonts.amaranth(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(18),
              child: RichText(
                textScaleFactor: 1.3,
                text: TextSpan(
                    text: "   Lorem Ipsum é simplesmente um texto fictício"
                        " da indústria tipográfica e de impressão. "
                        "Lorem Ipsum é o texto fictício padrão do setor "
                        "desde os anos 1500, quando uma impressora "
                        "desconhecida pegou uma galera do tipo e a mexeu "
                        "para fazer um livro de amostras do tipo."
                        " Ele sobreviveu não apenas cinco séculos,"
                        " mas também o salto para a composição eletrônica,"
                        " permanecendo essencialmente inalterado."
                        " Foi popularizado na década de 1960 com o "
                        "lançamento de folhas de Letraset contendo"
                        " passagens de Lorem Ipsum e, mais recentemente,"
                        " com software de editoração eletrônica como o "
                        "Aldus PageMaker, incluindo versões do Lorem Ipsum.",
                  style: GoogleFonts.amaranth(
                    color: Colors.black,
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
