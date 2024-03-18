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
	

procedure cargarFile (var arch:archivo);
var
	e:empleado;
	path:string;
begin
	{C:\Users\Julian\Desktop\FOD\datos.dat}
	write('Ingresar path: ');
	readln(path);
	assign(arch,path);
	rewrite(arch);
	write('Apellido: ');readln(e.ape);
	while(e.ape <> 'fin') do begin
		write('Nombre: ');readln(e.nom);
		write('Numero: ');readln(e.num);
		write('Edad: ');readln(e.edad);
		write('Dni: ');readln(e.dni);
		write(arch,e);
		writeln;
		write('Apellido: ');readln(e.ape);
	end;
	close(arch);
end;

procedure datoDeterminado(var arch:archivo);
var
	dato:string[15];
	emp:empleado;
begin
	reset(arch);
	write('Ingrese dato: ');readln(dato);
	while (not EOF(arch)) do begin
		read(arch,emp);
		if ((emp.nom = dato) or (emp.ape = dato)) then writeln('Empleado ',emp.nom,' ',emp.ape);
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
	
procedure proximosJubilarse(var arch:archivo);
var
	emp:empleado;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,emp);
		if (emp.edad > 70) then writeln('Proximos jubilarse: ',emp.nom,' ',emp.ape);
	end;
	close(arch);
end;
	
procedure buscarPorNumero (var arch:archivo; var esta:boolean; numEmp:integer);
var
	emp:empleado;
begin
	reset(arch);
	while ((not EOF(arch)) and (not esta)) do begin
		read(arch,emp);
		if (numEmp = emp.num) then esta := true;
	end;
	if (esta) then writeln('El empleado ESTA')
	else writeln('El empleado NO esta');
	//saque el close(arch) de aca y no me tiro mas el error
end;

procedure agregarEmpleado(var arch:archivo);
var
	e:empleado;
	esta:boolean;
begin
	esta:=false;
	reset(arch);
	write('Numero: ');readln(e.num);
	buscarPorNumero(arch,esta,e.num);
	if (not esta) then begin
		write('Nombre: ');readln(e.nom);
		write('Apellido: ');readln(e.ape);
		write('Edad: ');readln(e.edad);
		write('Dni: ');readln(e.dni);
		write(arch,e);
	end;
	close(arch);
end;

procedure modificarEdad (var arch:archivo);
var
	num,edad:integer;
	esta:boolean;
	emp:empleado;
begin
	esta:= false;
	writeln('Ingrese NUM a buscar');readln(num);
	writeln('Ingrese EDAD a actualizar');readln(edad);

	reset(arch);
	while ((not EOF(arch)) and (not esta)) do begin
		read(arch,emp);
		if (num = emp.num) then begin
			emp.edad := edad;
			seek(arch,filepos(arch) - 1); //filepos devuelve la pos del sig
			write(arch,emp);
			esta:=true;
		end;
	end;
	close(arch);
end;
		
procedure exportarContenido (var arch:archivo; var archTodo:archivo);
var
	emp:empleado;
begin
	assign(archTodo,'C:\Users\Julian\Desktop\FOD\todos_empleados.txt');
	rewrite(archTodo);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,emp);
		write(archTodo,emp);
	end;
	close(arch);
	close(archTodo);
end;

procedure exportarSinDni(var arch,archivoSinDni:archivo);
var
	emp:empleado;
begin
	assign(archivoSinDni,'C:\Users\Julian\Desktop\FOD\faltaDNIEmpleado.txt');
	rewrite(archivoSinDni);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,emp);
		if (emp.dni = 00) then write(archivoSinDni,emp);
	end;
	close(arch);
	close(archivoSinDni);
end;

procedure menu (var arch,archivoTodos,archivoSinDni:archivo);
var
	op:integer;
begin
	writeln('1-Crear archivo');
	writeln('2-Listar empleado determinado');
	writeln('3-Imprimir empleados');
	writeln('4-Listar proximos a jubilarse');
	writeln('5-Anadir mas empleados');
	writeln('6-Modificar edad de un empleado');
	writeln('7-Exportar contenido');
	writeln('8-Exportar empleados con DNI 00');
	writeln('0-Salir');
	writeln('Ingrese opcion:');
	readln(op);
	while (op <> 0) do begin
		case op of 
			1: cargarFile(arch);
			2: datoDeterminado(arch);
			3: imprimirEmpleados(arch);
			4: proximosJubilarse(arch);
			5: agregarEmpleado(arch);
			6: modificarEdad(arch);
			7: exportarContenido(arch,archivoTodos);
			8: exportarSinDni(arch,archivoSinDni);
		end;
		writeln('1-Crear archivo');
		writeln('2-Listar empleado determinado');
		writeln('3-Imprimir empleados');
		writeln('4-Listar proximos a jubilarse');
		writeln('5-Anadir mas empleados');
		writeln('6-Modificar edad de un empleado');
		writeln('7-Exportar contenido');
		writeln('8-Exportar empleados con DNI 00');
		writeln('0-Salir');
		writeln('Ingrese opcion:');
		readln(op);
	end;
end;

var
	arch,archivoTodos,archivoSinDni:archivo;
BEGIN
	menu(arch,archivoTodos,archivoSinDni);
END.
