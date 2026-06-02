create schema portal_estudantil;

create table usuario(
	codUsuario int comment "identificador do usuario",
	login varchar(255) comment "login do usuario",
	senha varchar(255) comment "senha do usuario",
	cargo varchar(255) comment "cargo do usuario",
	primary key(codUsuario)
);

create table aluno(
	codAluno int comment "identificador do aluno",
	matriculaAluno int comment "matricula do aluno",
	cpf varchar(20) comment "cpf do aluno",
	dataNasc date comment "nascimento do aluno",
	nome varchar(255) comment "nome do aluno",
	codUsuario int comment "codigo do usuário do aluno",
	primary key(codAluno)
);

create table curso(
	codCurso int comment "",
	nome varchar(255) comment "",
	codAluno int comment "",
	codProfessor int comment "",
	codMateria int comment "",
	primary key(codCurso)
);

create table professor(
	codProfessor int comment "",
	dataNasc date comment "",
	matriculaProfessor int comment "",
	cpf varchar(20) comment "",
	nome varchar(255) comment "",
	codUsuario int comment "",
	primary key(codProfessor)
);

create table materia(
	codMateria int comment "",
	horario time comment "",
	nome varchar(255) comment "",
	sala varchar(255) comment "",
	codProfessor int comment "",
	primary key(codMateria)
);

create table professorCurso(
	codProfessorCurso int comment "",
	codProfessor int comment "",
	codCurso int comment "", 
	primary key(codProfessorCurso)
);

create table CursoMateria(
	codCursoMateria int comment "",
	codMateria int comment "",
	codCurso int comment "",
	primary key(codCursoMateria)
);
