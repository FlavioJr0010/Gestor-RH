class Usuario {
  // ADICIONE O 'final' AQUI 👇
  final String id;
  final String nome;
  final String email;
  final String senha;

  // AGORA VOCÊ PODE ATÉ USAR 'const' NO CONSTRUTOR 👍
  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // O resto do seu código continua igual...
  Map<String, dynamic> toMap() => {
        'nome': nome,
        'email': email,
        'senha': senha,
      };

  factory Usuario.fromMap(String id, Map<String, dynamic> map) => Usuario(
        id: id,
        nome: map['nome'] ?? '',
        email: map['email'] ?? '',
        senha: map['senha'] ?? '',
      );
}