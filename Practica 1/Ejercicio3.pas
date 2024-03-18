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
		writeln('Empleado ',emp.nom,' ',emp.ape);
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

procedure menu (var arch:archivo);
var
	op:integer;
begin

	writeln('1-Crear archivo');
	writeln('2-Listar empleado determinado');
	writeln('3-Imprimir empleados');
	writeln('4-Listar proximos a jubilarse');
	writeln('0-Salir');
	writeln('Ingrese opcion:');
	readln(op);
	while (op <> 0) do begin
		case op of 
			1: cargarFile(arch);
			2: datoDeterminado(arch);
			3: imprimirEmpleados(arch);
			4: proximosJubilarse(arch);
		end;
		writeln('1-Crear archivo');
		writeln('2-Listar empleado determinado');
		writeln('3-Imprimir empleados');
		writeln('4-Listar proximos a jubilarse');
		writeln('0-Salir');
		writeln('Ingrese opcion:');
		readln(op);
	end;
end;
	
var
	arch:archivo;
BEGIN
	menu(arch);
END.

