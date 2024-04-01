program ea;
type
	str = string[20];
	empleado = record
		nombre:str;
		codigo:integer;
		monto:real;
	end;
	
	archivo = file of empleado;
	
procedure imprimirBinario (var arch:archivo);
	procedure imprimirEmpleado(e:empleado);
	begin
		writeln('CODIGO: ',e.codigo);
		writeln('MONTO: ',e.monto:0:2);
		writeln('NOMBRE: ',e.nombre);
		writeln();
	end;
var
	e:empleado;
begin	
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,e);
		imprimirEmpleado(e);
	end;
	close(arch);
end;

procedure imprimirTexto (var arch:Text);
	procedure imprimirEmpleado(e:empleado);
	begin
		writeln('CODIGO: ',e.codigo);
		writeln('MONTO: ',e.monto:0:2);
		writeln('NOMBRE: ',e.nombre);
		writeln();
	end;
var
	e:empleado;
begin	
	reset(arch);
	while (not EOF(arch)) do begin
		readln(arch,e.codigo,e.monto,e.nombre);
		imprimirEmpleado(e);
	end;
	close(arch);
end;

procedure leer(	var arch: Text; var e:empleado );
begin
    if (not(EOF(arch))) then 
		readln(arch,e.codigo,e.monto,e.nombre)
    else 
		e.codigo := 999;
		
end;


procedure acumularComisiones (var arch:Text; var archNuevo:archivo);
var
	e:empleado;
	eActual:empleado;
begin
	rewrite(archNuevo);
	reset(arch);
	leer(arch,e);
	while (e.codigo <> 999) do begin;
		eActual.codigo := e.codigo;
		eActual.nombre := e.nombre;
		eActual.monto:=0;
		while (e.codigo <> 999) and (eActual.codigo = e.codigo) do begin
			eActual.monto := eActual.monto + e.monto;
			leer(arch,e);
		end;
		//asignaciones cuando encuentra alguno distinto
		write(archNuevo,eActual);
	end;
	close(arch);
	close(archNuevo);
end;

var
	arch:Text;
	archNuevo:archivo;
begin
	assign(arch,'empleadosEj1.txt');
	assign(archNuevo,'empleado2');
	imprimirTexto(arch);
	acumularComisiones(arch,archNuevo);
	writeln();
	imprimirBinario(archNuevo);
	
end.
