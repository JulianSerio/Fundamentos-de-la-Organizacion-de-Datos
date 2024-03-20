program untitled;
type
	str = string[20];
	novela = record	
		cod:integer;
		nombre:str;
		genero:str;
		precio:real;
	end;
	
	archivo = file of novela;

procedure cargarArchivo (var arch:archivo; var archivoNovelas:Text);
var
	n:novela;
begin
	rewrite(arch);
	reset(archivoNovelas);
	while (not EOF(archivoNovelas)) do begin
		readln(archivoNovelas,n.cod,n.precio,n.genero);
		readln(archivoNovelas,n.nombre);
		write(arch,n);
		writeln('uopapap');
	end;
	close(arch);
	close(archivoNovelas);
end;

procedure leer (var n:novela);
begin
	writeln('CODIGO: ');readln(n.cod);
	writeln('NOMBRE: ');readln(n.nombre);
	writeln('GENERO: ');readln(n.genero);
	writeln('PRECIO: ');readln(n.precio);
	writeln();
end;

procedure modificarNovela (var arch:archivo);
var
	cod:integer;
	nov:novela;
begin
	write('INGRESE CODIGO DE NOVELA A MODIFICAR');readln(cod);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,nov);
		if (nov.cod = cod) then begin
			writeln;
			leer(nov);
			seek(arch,filepos(arch) - 1);
			write(arch,nov);
		end;
	end;
	close(arch);
end;

procedure agregarNovela (var arch:archivo);
var
	n:novela;
begin
	leer(n);
	reset(arch);
	seek(arch,filesize(arch));
	write(arch,n);
	close(arch);
end;

procedure imprimirContenido (var arch:archivo);
	procedure imprimirNovela (n:novela);
	begin
		writeln('CODIGO: ',n.cod);
		writeln('NOMBRE: ',n.nombre);
		writeln('GENERO: ',n.genero);
		writeln('PRECIO: ',n.precio);
	end;
var
	n:novela;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,n);
		writeln('-------------------');
		imprimirNovela(n);
	end;
	close(arch);
end;

procedure menu (var arch:archivo; var archivoNovelas:Text);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar archivo');
		writeln('2-Modificar novela');
		writeln('3-Agregar novela');
		writeln('4-Imprimir');
		writeln('0-Salir');
		readln(op)
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1:cargarArchivo(arch,archivoNovelas);
			2:modificarNovela(arch);
			3:agregarNovela(arch);
			4:imprimirContenido(arch);
		end;
		mostrarOpciones(op);
	end;
end;

var
	arch:archivo;
	nombre:str;
	archivoNovelas:Text;
BEGIN
	write('INGRESE NOMBRE: ');readln(nombre);
	assign(arch,nombre);
	assign(archivoNovelas,'novelas.txt');
	menu(arch,archivoNovelas);
END.

