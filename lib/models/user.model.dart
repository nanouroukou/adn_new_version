class User {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nom;
  String? prenom;
  String? phone;
  String? dateNaissance;
  String? prenomPere;
  String? prenomMere;
  String? nomMere;
  String? login;
  String? role;
  String? registerAgent;

  User({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.nom,
    this.prenom,
    this.phone,
    this.dateNaissance,
    this.prenomPere,
    this.prenomMere,
    this.nomMere,
    this.login,
    this.role,
    this.registerAgent,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nom: json['nom'],
      prenom: json['prenom'],
      phone: json['phone'],
      dateNaissance: json['dateNaissance'],
      prenomPere: json['prenomPere'],
      prenomMere: json['prenomMere'],
      nomMere: json['nomMere'],
      login: json['login'],
      role: json['role'],
      registerAgent: json['registerAgent'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['nom'] = nom;
    map['prenom'] = prenom;
    map['phone'] = phone;
    map['dateNaissance'] = dateNaissance;
    map['prenomPere'] = prenomPere;
    map['prenomMere'] = prenomMere;
    map['nomMere'] = nomMere;
    map['login'] = login;
    map['role'] = role;
    map['registerAgent'] = registerAgent;
    return map;
  }
}
