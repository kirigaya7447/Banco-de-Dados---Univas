create table usuario(
	codUsuario int,
	login varchar(255),
	senha varchar(255),
	cargo varchar(255),
	primary key(codUsuario)
);

create table aluno(
	codAluno int,
	matriculaAluno int,
	cpf varchar(20),
	dataNasc date,
	nome varchar(255),
	codUsuario int,
	primary key(codAluno)
);

create table curso(
	codCurso int,
	nome varchar(255),
	codAluno int,
	codProfessor int,
	codMateria int,
	primary key(codCurso)
);

create table professor(
	codProfessor int,
	dataNasc date,
	matriculaProfessor int,
	cpf varchar(20),
	nome varchar(255),
	codUsuario int,
	primary key(codProfessor)
);

create table materia(
	codMateria int,
	horario time,
	nome varchar(255),
	sala varchar(255),
	codProfessor int,
	primary key(codMateria)
);

create table professorCurso(
	codProfessorCurso int,
	codProfessor int,
	codCurso int, 
	primary key(codProfessorCurso)
);

create table CursoMateria(
	codCursoMateria int,
	codMateria int,
	codCurso int,
	primary key(codCursoMateria)
);