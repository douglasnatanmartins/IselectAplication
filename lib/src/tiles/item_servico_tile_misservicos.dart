import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';

class ItemServicoTileMeusServicos extends StatelessWidget {
  ModelServico servico;
  VoidCallback onTapItem;
  VoidCallback onTapRemover;

  ItemServicoTileMeusServicos({
    @required this.servico,
    @required this.onTapItem,
    @required this.onTapRemover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
        child: Container(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 1.0),
                )
              ],
              gradient: LinearGradient(colors: [
                Colors.orange[400],
                Colors.orange[300],
                Colors.orange[200],
              ], begin: Alignment.bottomRight, end: Alignment.topLeft),
              color: Colors.black,
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
              title: Text(
                servico.title,
                style: GoogleFonts.amaranth(textStyle: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline
                )),
              ),
              subtitle: Text(
                servico.preco,
                style: GoogleFonts.amaranth(textStyle: TextStyle(
                  fontSize: 15,
                )),
              ),
              leading: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: NetworkImage(servico.fotos[0]),
                        fit: BoxFit.cover)),
              ),
              trailing: this.onTapRemover != null
                  ? IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                    size: 30,
                  ),
                  onPressed: this.onTapRemover)
                  : Text("")),
        ),
      ),
    );
  }
}
