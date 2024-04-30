program untitled;

type
	empleado = record
		num:integer;
		ape:string[15];
		nom:string[15];
		edad:integer;
		dni:integer;
	end;
	
	archivo = file of empleado;


procedure borrarRegistro (var arch:archivo);
var
	e:empleado;
	ultReg:empleado;
	num,pos:integer;
	encontre:boolean;
begin
	write('Ingrese numero de empleado: ');readln(num);
	reset(arch);
	encontre := false;
	while (not EOF(arch)) and (not encontre) do begin //mientras no sea el final del archivo
		read(arch,e); //leo el registro
		if (e.num = num) then begin //si el actual es el que estoy buscando
			encontre:=true;
			pos:= filepos(arch)-1; //tomo la pos donde lo encontre
			seek(arch,filesize(arch)-1);//me posiciono en el ultimo elemento
 			read(arch,ultReg); //leo el registro de la ultima posicion
 			seek(arch,pos); //me posiciono en la pos donde encontre 
 			write(arch,ultReg); //escribo el ultimo registro en la pos donde encontre
 			truncate(arch); //elimino la ultima posicion
		end;
	end;
	if (not encontre) then 
		writeln('NO encontre el elemento')
	else
		writeln('');
	close(arch);
end;

procedure menu (var arch:archivo);
	procedure cargarFile (var arch:archivo);
	var
		e:empleado;
	begin
		rewrite(arch);
		with e do begin
			write ('INGRESE APELLIDO DE EMPLEADO: '); readln (ape);
			while (ape <> 'ZZZ') do begin
				write ('INGRESE NOMBRE DE EMPLEADO: '); readln (nom);
				write ('INGRESE NRO DE EMPLEADO: '); readln (num);
				write ('INGRESE EDAD DE EMPLEADO: '); readln (edad);
				write ('INGRESE DNI DE EMPLEADO: '); readln (dni);
				write(arch,e);
				writeln();
				write ('INGRESE APELLIDO DE EMPLEADO: '); readln (ape);
			end;	
		end;
		close(arch);
	end;


	procedure imprimirEmpleados(var arch:archivo);
	var
		emp:empleado;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,emp);
			writeln('Nombre: ',emp.nom);
			writeln('Apellido: ',emp.ape);
			writeln('DNI: ',emp.dni);
			writeln('Edad: ',emp.edad);
			writeln('Numero: ',emp.num);
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
			3: borrarRegistro(arch);
		end;
		mostrarOpciones(op);
	end;
end;

var
	arch:archivo;
BEGIN
	assign(arch,'pruebaEJ1');
	menu(arch);
END.
