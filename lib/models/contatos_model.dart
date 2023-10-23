class ContatosModel {
  List<Contato> contatosLista = [];

  ContatosModel(this.contatosLista);

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatosLista = <Contato>[];
      json['results'].forEach((v) {
        contatosLista!.add(Contato.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contatosLista != null) {
      data['results'] = contatosLista!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contato {
  String objectId = "";
  String nome = "";
  String foto = "";
  String telefone = "";
  String createdAt = "";
  String updatedAt = "";

  Contato(this.objectId, this.nome, this.foto, this.telefone, this.createdAt,
      this.updatedAt);

  Contato.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    foto = json['foto'];
    telefone = json['telefone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectId'] = this.objectId;
    data['nome'] = this.nome;
    data['foto'] = this.foto;
    data['telefone'] = this.telefone;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  Map<String, dynamic> salvarJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['nome'] = nome;
    data['foto'] = foto;
    data['telefone'] = telefone;

    return data;
  }
}
