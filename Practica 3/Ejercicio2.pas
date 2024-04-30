program untitled;
type
	str = string[20];
	asistente = record
		numero:integer;
		nombreYapellido:str;
		email:str;
		telefono:integer;
		dni:integer;
	end;
	
	archMaestro = file of asistente;
	
procedure borrarRegistros (var arch:archMaestro);
var
	regMaestro:asistente;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,regMaestro);
		if (regMaestro.numero < 1000) then begin
			regMaestro.nombreYapellido := '#'+regMaestro.nombreYapellido;
			seek(arch,filepos(arch)-1);
			write(arch,regMaestro);
		end;
	end;
	close(arch);
end;
	
procedure menu (var arch:archMaestro);
	procedure cargarFile (var arch:archMaestro);
	var
		a:asistente;
	begin
		rewrite(arch);
		with a do begin
			write ('NUMERO: '); readln (numero);
			while (numero <> 0) do begin
				write ('NOMBRE Y APELLIDO: '); readln (nombreYapellido);
				write ('DNI: '); readln (dni);
				write ('EMAIL: '); readln (email);
				write ('TELEFONO: '); readln (telefono);
				write(arch,a);
				writeln();
				write ('NUMERO: '); readln (numero);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirEmpleados(var arch:archMaestro);
	var
		a:asistente;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			writeln('Numero: ',a.numero);
			writeln('Nombre y Aellido: ',a.nombreYapellido);
			writeln('Dni: ',a.dni);
			writeln('Email: ',a.email);
			writeln('Telefono: ',a.telefono);
			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Crear archivo');
		writeln('2-Imprimir empleados');
		writeln('3-Borrar empleado');
		readln(op);
	end;


var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarFile(arch);
			2: imprimirEmpleados(arch);
			3: borrarRegistros(arch);
		end;
		mostrarOpciones(op);
	end;
end;

var
	maestro:archMaestro;
BEGIN
	assign(maestro,'maestroEJ2');
	menu(maestro);
END.

