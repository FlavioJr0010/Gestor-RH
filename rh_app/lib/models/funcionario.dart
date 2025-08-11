// lib/models/funcionario.dart
class Funcionario {
  final String id;
  final String nome;
  final String email; // Campo de e-mail presente
  final double salario;
  final String telefone;
  final String cargo;
  final String status;
  final String endereco;
  final String statusCivil;

  const Funcionario({
    required this.id,
    required this.nome,
    required this.email, // Exigindo o e-mail
    required this.salario,
    required this.telefone,
    required this.cargo,
    required this.status,
    required this.endereco,
    required this.statusCivil,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'salario': salario,
      'telefone': telefone,
      'cargo': cargo,
      'status': status,
      'endereco': endereco,
      'statusCivil': statusCivil,
    };
  }

  factory Funcionario.fromMap(Map<String, dynamic> map, String documentId) {
    return Funcionario(
      id: documentId,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '', // Lendo o e-mail
      salario: (map['salario'] as num?)?.toDouble() ?? 0.0,
      telefone: map['telefone'] ?? '',
      cargo: map['cargo'] ?? '',
      status: map['status'] ?? 'Ativo',
      endereco: map['endereco'] ?? '',
      statusCivil: map['statusCivil'] ?? '',
    );
  }
}