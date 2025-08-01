// models/funcionario.dart

class Funcionario {
  final String id;
  final String nome;
  final double salario; // Mudei para double
  final String telefone;
  final String cargo;
  final String status;
  final String endereco;
  final String statusCivil;

  Funcionario({
    required this.id,
    required this.nome,
    required this.salario,
    required this.telefone,
    required this.cargo,
    required this.status,
    required this.endereco,
    required this.statusCivil,
  });

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'salario': salario,
        'telefone': telefone,
        'cargo': cargo,
        'status': status,
        'endereco': endereco,
        'statusCivil': statusCivil,
      };

  factory Funcionario.fromMap(String id, Map<String, dynamic> map) => Funcionario(
        id: id,
        nome: map['nome'] ?? '',
        // Garantindo que os valores padrão evitem erros
        salario: (map['salario'] ?? 0).toDouble(),
        telefone: map['telefone'] ?? '',
        cargo: map['cargo'] ?? '',
        status: map['status'] ?? 'Inativo',
        endereco: map['endereco'] ?? 'Não informado',
        statusCivil: map['statusCivil'] ?? 'Não informado',
      );
}