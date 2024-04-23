program untitled;
const
	VALOR_BAJO = -999;
type	
	str = string[20];
	novela = record
		codigo:integer;
		genero:str;
		nombre:str;
		duracion:integer;
		director:str;
		precio:real;
	end;
	
	archMaestro = file of novela;
	
	
procedure darAlta (var arch:archMaestro);
var
	n,nPri:novela;
	posNeg:integer;
	reg:novela;
begin
	write ('CODIGO: '); readln (n.codigo);
	write ('GENERO: '); readln (n.genero);
	write ('NOMBRE: '); readln (n.nombre);
	write ('DURACION: '); readln (n.duracion);
	write ('DIRECTOR: '); readln (n.director);
	write ('PRECIO: '); readln (n.precio);
	reset(arch);
	read(arch,nPri);
	if (nPri.codigo < 0) then begin //si el valor es menor a 0
		posNeg := -1 * n.codigo; //convierto la pos negativa a positiva
		seek(arch,posNeg); //me posiciono
		read(arch,reg); //leo lo que hay en esa posicion
		write(arch,n); //reescribo lo que habia en el reg 0 
		seek(arch,0); //me posiciono
		write(arch,reg); //reescribo lo que habia en la pos positiva 
	end
	else begin
		seek(arch,filesize(arch));
		write(arch,n);
	end;
	close(arch);
end;

procedure modificarDatos (var arch:archMaestro);
var
	cod:integer;
	encontre:boolean;
	n:novela;
begin
	write('CODIGO DE NOVELA A MODIFICAR: ');readln(cod);
	encontre:=false;
	reset(arch);
	while (not EOF(arch)) and (not encontre) do begin
		read(arch,n);
		if (n.codigo = cod) then begin
			write ('GENERO: '); readln (n.genero);
			write ('NOMBRE: '); readln (n.nombre);
			write ('DURACION: '); readln (n.duracion);
			write ('DIRECTOR: '); readln (n.director);
			write ('PRECIO: '); readln (n.precio);
			seek(arch,filepos(arch)-1);
			write(arch,n);
			encontre:=true;
		end;
	end;
	close(arch);
end;

procedure eliminarNovela (var arch:archMaestro);
var
	encontre:boolean;
	cod,posNeg,posEncontre:integer;
	n,head:novela;
begin
	encontre:=false;
	reset(arch);
	write('INGRESE CODIGO DE NOVELA: ');readln(cod);
	while (not EOF(arch)) and (not encontre) do begin
		read(arch,n);
		if (n.codigo = cod) then begin
			posEncontre:= filepos(arch)-1; //guardo la pos de donde encontre;
			posNeg:= posEncontre * -1;  //convierto la posicion a negativa
			
			n.codigo := posNeg; //asigno la posicion negativa al reg actual a eliminar
			
			seek(arch,0); //me posicion en la cabecera
			read(arch,head); //leo la cabecera
			seek(arch,filepos(arch)-1); //vuelvo a la cabecera
			write(arch,n); //escribo el reg eliminado
			
			seek(arch,posEncontre); //me posiciono donde encontre 
			write(arch,head); //escribo el reg de la cabecera		
			encontre:=true;
		end;
	end;
	close(arch);
end;

procedure listarATexto (var arch:archMaestro; var texto:Text);
var
	n:novela;
begin
	rewrite(texto);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,n);
		writeln(texto,'Codigo: ',n.codigo,' Precio: ',n.precio:2:0,' Duracion: ',n.duracion);
		writeln(texto,'Nombre: ',n.nombre,' Director: ',n.director);
		writeln(texto,' ');
	end;
	close(arch);
	close(texto);
end;

procedure menu (var arch:archMaestro; var texto:Text);
	procedure cargarFile (var arch:archMaestro);
	var
		n:novela;
	begin
		rewrite(arch);
		with n do begin
			codigo := 0;
			genero := 'ZZZ';
			nombre := 'ZZZ';
			duracion:= VALOR_BAJO;
			director:= 'ZZZ'; 
			precio:= VALOR_BAJO;
			write(arch,n);
			
			write ('CODIGO: '); readln (codigo);
			while (codigo <> 0) do begin
				write ('GENERO: '); readln (genero);
				write ('NOMBRE: '); readln (nombre);
				write ('DURACION: '); readln (duracion);
				write ('DIRECTOR: '); readln (director);
				write ('PRECIO: '); readln (precio);
				write(arch,n);
				writeln();
				write ('CODIGO: '); readln (codigo);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirNovelas(var arch:archMaestro);
	var
		n:novela;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,n);
			writeln('CODIGO: ',n.codigo);
			writeln('GENERO: ',n.genero);
			writeln('NOMBRE: ',n.nombre);
			writeln('DURACION: ',n.duracion);
			writeln('DIRECTOR: ',n.director);
			writeln('PRECIO: ',n.precio:2:0);

			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar archivo');
		writeln('2-Imprimir novelas');
		writeln('3-Dar alta');
		writeln('4-Borrar novela');
		writeln('5-Modificar novela');
		writeln('6-Listar a texto');
		writeln('0-Finalizar');
		readln(op);
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarFile(arch);
			2: imprimirNovelas(arch);
			3: darAlta(arch);
			4: eliminarNovela(arch);
			5: modificarDatos(arch);
			6: listarATexto(arch,texto);
		end;
		mostrarOpciones(op);
	end;
end;

var
	maestro:archMaestro;
	texto:Text;
BEGIN
	assign(texto,'novelas.txt');
	assign(maestro,'maestroEJ3');
	menu(maestro,texto);
END.

