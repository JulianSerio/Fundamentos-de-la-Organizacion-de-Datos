program untitled;
type 
	str = string[20];
	ave = record
		codigo:integer;
		nombre:str;
		familia:str;
		descripcion:str;
		zona:str;
	end;
	
	archMaestro = file of ave;
	
procedure eliminarEspecies (var arch:archMaestro);
	procedure marcarRegistros (var arch:archMaestro; cod:integer);
	var
		a:ave;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			if (a.codigo = cod) then begin
				a.codigo := 0;
				seek(arch,filepos(arch)-1);
				write(arch,a);
			end;
		end;
		close(arch);
	end;
	
	procedure borrarRegistros (var arch:archMaestro);
	var
		a:ave;
		aUlt:ave;
		posEncontre:integer;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			if (a.codigo = 0) then begin
				posEncontre := filepos(arch)-1;//tomo la pos actual
				seek(arch,filesize(arch)-1);  //voy al final de archivo
				read(arch,aUlt); 			 //leo el ultimo reg
				seek(arch,posEncontre);		 //vuelvo en a la pos donde encontre el reg
				write(arch,aUlt); 			 //sobreescribo el reg con cod 0
				seek(arch,filesize(arch)-1);
				truncate(arch);
			end;
		end;
		close(arch);
	end;
var
	cod:integer;
begin
	write('INGRESE CODIGO DE ESPECIE: ');readln(cod);
	while (cod <> 0) do begin
		marcarRegistros(arch,cod);
		borrarRegistros(arch);
		write('INGRESE CODIGO DE ESPECIE: ');readln(cod);
	end;
end;
	
procedure menu (var arch:archMaestro);
	procedure cargarMaestro (var arch:archMaestro);
	var
		a:ave;
	begin
		rewrite(arch);
		with a do begin
			write ('CODIGO: '); readln (codigo);
			while (codigo <> 0) do begin
				nombre := 'X';
				familia := 'Y';
				descripcion := 'Z';
				zona := 'S';
				write(arch,a);
				writeln();
				write ('CODIGO: '); readln (codigo);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirMaestro(var arch:archMaestro);
	var
		a:ave;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			writeln('CODIGO: ',a.codigo);
			writeln('NOMBRE: ',a.nombre);
			writeln('FAMILIA: ',a.familia);
			writeln('DESCRIPCION: ',a.descripcion);
			writeln('ZONA GEOGRAFICA: ',a.zona);
			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Imprimir maestro');
		writeln('3-Eliminar especies');
		writeln('0-Finalizar');
		readln(op);
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarMaestro(arch);
			2: imprimirMaestro(arch);
			3: eliminarEspecies(arch);
		end;
		mostrarOpciones(op);
	end;
end;
	
var
	arch:archMaestro;
BEGIN
	assign(arch,'maestroEJ7');
	menu(arch);
END.

