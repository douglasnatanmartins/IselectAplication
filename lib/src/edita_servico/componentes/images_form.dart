import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/widgets/image_source_dialog.dart';

class ImagesForm extends StatelessWidget {

  final ModelServico product;
  // ignore: use_key_in_widget_constructors
  const ImagesForm(this.product);

  @override
  Widget build(BuildContext context) {

    return FormField<List<dynamic>>(
      initialValue: List.from(product.fotos),
      validator: (images){
        if(images.isEmpty){
          return "Erro: Insira ao menos uma imagem!";
        }
        return null;
      },
      onSaved: (images) => product.newImages = images,
      builder: (state){

        void onImageSelect(File file){
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image){
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if(image is String)
                        Image.network(image, fit: BoxFit.cover,)
                      else
                        Image.file(image as File, fit: BoxFit.cover),
                      //Image
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete_forever,
                            size: 35,
                            color: Colors.red,
                          ),
                          onPressed: (){
                            showDialog(context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  title: Text(
                                    "Deseja excluir a imagem?",
                                    style: GoogleFonts.amaranth(
                                        color: Colors.grey[600]
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Não",
                                        style: GoogleFonts.amaranth(
                                            fontSize: 18,
                                            color: Colors.red
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        state.value.remove(image);
                                        state.didChange(state.value);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Sim",
                                        style: GoogleFonts.amaranth(
                                            fontSize: 18,
                                            color: Colors.grey
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            );
                          },
                        ),
                      )
                    ],
                  );
                }).toList()..add(
                    Material(
                        color: Colors.grey[200],
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          iconSize: 50,
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            showDialog(context: context,
                                builder: (context) => ImageSouceDialog(
                                  onImageSlected: onImageSelect,
                                )
                            );
                          },
                        )
                    )
                ),
                autoplay: false,
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.black12.withAlpha(30),
                dotColor:Theme.of(context).primaryColor,
                autoplayDuration: const Duration(seconds: 8),
              ),
            ),
            if(state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: GoogleFonts.amaranth(
                      color: Colors.red
                  ),
                ),
              )

          ],
        );
      },
    );
  }
}
