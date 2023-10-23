import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listacontatos/pages/listagem_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import '../models/contatos_model.dart';
import '../repositories/contatos_repository.dart';

class CadastroPage extends StatefulWidget {
  final String id;
  const CadastroPage(this.id, {super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState(id);
}

class _CadastroPageState extends State<CadastroPage> {
  final String id;
  var nomeController = TextEditingController();
  var telefoneController = TextEditingController();
  _CadastroPageState(this.id);

  var carregando = false;
  ContatosRepository instanciaRepository = ContatosRepository();
  String caminhoFoto = "";
  XFile? photo = XFile("");
  Contato _contato = Contato.vazio();

  get child => null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obterContatos();
  }

  obterContatos() async {
    if (id != "0") {
      setState(() {
        carregando = true;
      });

      _contato = await instanciaRepository.obterContatoEspecifico(id);
      caminhoFoto = _contato.foto;
      telefoneController.text = _contato.telefone;
      nomeController.text = _contato.nome;
      setState(() {
        carregando = false;
      });
    }
  }

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      maxHeight: 250,
      maxWidth: 250,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
    }
    caminhoFoto = croppedFile!.path;
    print("Caminho Foto: $caminhoFoto");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: FaIcon(FontAwesomeIcons.backward),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ListagemPage()));
          },
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: caminhoFoto != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                caminhoFoto.startsWith("http")
                                    ? Image.network(
                                        _contato.foto,
                                        fit: BoxFit.cover,
                                        scale: 1.0,
                                        height: 250,
                                        width: double.infinity,
                                      )
                                    : Image.file(
                                        File(caminhoFoto),
                                        scale: 1.0,
                                        height: 250,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (_) {
                                            return Wrap(
                                              children: [
                                                ListTile(
                                                  leading: FaIcon(
                                                      FontAwesomeIcons.camera),
                                                  title: Text("Camera"),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    final ImagePicker picker =
                                                        ImagePicker();
                                                    photo =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .camera);
                                                    if (photo != null) {
                                                      String path =
                                                          (await path_provider
                                                                  .getApplicationDocumentsDirectory())
                                                              .path;
                                                      String name =
                                                          basename(photo!.path);
                                                      print("${path}/${name}");
                                                      await photo!.saveTo(
                                                          "${path}/${name}");

                                                      cropImage(photo!);
                                                      caminhoFoto = photo!.path;

                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                                ListTile(
                                                  leading: FaIcon(
                                                      FontAwesomeIcons.image),
                                                  title: Text("Galeria"),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    final ImagePicker picker =
                                                        ImagePicker();
                                                    photo =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                    caminhoFoto = photo!.path;
                                                    cropImage(photo!);

                                                    setState(() {});
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: FaIcon(FontAwesomeIcons.camera))
                              ],
                            )
                          : Container(
                              color: Colors.black,
                              child: InkWell(
                                onTap: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        return Wrap(
                                          children: [
                                            ListTile(
                                              leading: FaIcon(
                                                  FontAwesomeIcons.camera),
                                              title: Text("Camera"),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                photo = await picker.pickImage(
                                                    source: ImageSource.camera);
                                                if (photo != null) {
                                                  String path = (await path_provider
                                                          .getApplicationDocumentsDirectory())
                                                      .path;
                                                  String name =
                                                      basename(photo!.path);
                                                  print("${path}/${name}");
                                                  await photo!.saveTo(
                                                      "${path}/${name}");

                                                  cropImage(photo!);
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            ListTile(
                                              leading: FaIcon(
                                                  FontAwesomeIcons.image),
                                              title: Text("Galeria"),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                photo = await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                                cropImage(photo!);
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                            )),
                  carregando == true
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nome:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  controller: nomeController,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Telefone:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  controller: telefoneController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: 20),
                                  maxLength: 11,
                                  onChanged: (value) {
                                    if (telefoneController.text.length == 11) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 50,
                                    child: id != "0"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.blue)),
                                                onPressed: () async {
                                                  _contato.telefone =
                                                      telefoneController.text;
                                                  _contato.nome =
                                                      nomeController.text;
                                                  _contato.foto = caminhoFoto;
                                                  setState(() {});

                                                  await instanciaRepository
                                                      .atualizar(_contato);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Contato alterado com sucesso")));
                                                },
                                                child: Text(
                                                  "Alterar",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    await instanciaRepository
                                                        .deletar(id);

                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                const ListagemPage()));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Contato excluído com sucesso")));
                                                  },
                                                  child: Text(
                                                    "Deletar",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                            ],
                                          )
                                        : ElevatedButton(
                                            onPressed: () async {
                                              _contato.telefone =
                                                  telefoneController.text;
                                              _contato.nome =
                                                  nomeController.text;
                                              _contato.foto = caminhoFoto;
                                              setState(() {});
                                              print(_contato.nome +
                                                  _contato.telefone +
                                                  _contato.foto);
                                              await instanciaRepository
                                                  .criarContato(_contato);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const ListagemPage()));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Contato criado com sucesso")));
                                              setState(() {});
                                            },
                                            child: Text(
                                              "Cadastrar",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                  ),
                                )
                              ]),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
