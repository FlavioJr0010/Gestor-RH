// models/funcionario.dart
class Funcionario {
  String id;
  String nome;
  String cargo;
  String status;

  Funcionario({
    required this.id,
    required this.nome,
    required this.cargo,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'cargo': cargo,
        'status': status,
      };

  factory Funcionario.fromMap(String id, Map<String, dynamic> map) => Funcionario(
        id: id,
        nome: map['nome'] ?? '',
        cargo: map['cargo'] ?? '',
        status: map['status'] ?? '',
      );
}