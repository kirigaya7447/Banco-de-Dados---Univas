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
	codCurso int comment "identificador do curso",
	nome varchar(255) comment "nome do curso",
	codAluno int comment "identificador do aluno",
	codProfessor int comment "identificador do professor",
	codMateria int comment "identificador da Materia",
	primary key(codCurso)
);

create table professor(
	codProfessor int comment "identificador do professor",
	dataNasc date comment "data de nascimento do professor",
	matriculaProfessor int comment "matricula do professor",
	cpf varchar(20) comment "cpf do professor",
	nome varchar(255) comment "nome do professor",
	codUsuario int comment "identificador do usuario",
	primary key(codProfessor)
);

create table materia(
	codMateria int comment "identificador da materia",
	horario time comment "horario da aula da materia",
	nome varchar(255) comment "nome da materia",
	sala varchar(255) comment "sala da materia",
	codProfessor int comment "identificador do professor",
	primary key(codMateria)
);

create table professorCurso(
	codProfessorCurso int comment "identificador do ProfessorCurso",
	codProfessor int comment "identificador do professor",
	codCurso int comment "identificador do curso", 
	primary key(codProfessorCurso)
);

create table cursoMateria(
	codCursoMateria int comment "identificador do CursoMateria",
	codMateria int comment "identificador da materia",
	codCurso int comment "identificador do curso",
	primary key(codCursoMateria)
);

ALTER TABLE aluno
	ADD CONSTRAINT FOREIGN key(codUsuario)
	REFERENCES usuario(codUsuario)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE professor
	ADD CONSTRAINT FOREIGN key(codUsuario)
	REFERENCES usuario(codUsuario)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE professorCurso
	ADD CONSTRAINT FOREIGN key(codProfessor)
	REFERENCES professor(codProfessor)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE professorCurso
	ADD CONSTRAINT FOREIGN key(codCurso)
	REFERENCES curso(codCurso)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE cursoMateria
	ADD CONSTRAINT FOREIGN key(codMateria)
	REFERENCES materia(codMateria)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE cursoMateria
	ADD CONSTRAINT FOREIGN key(codCurso)
	REFERENCES curso(codCurso)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE curso
	ADD CONSTRAINT FOREIGN key(codAluno)
	REFERENCES aluno(codAluno)
	ON DELETE CASCADE
	ON UPDATE CASCADE;