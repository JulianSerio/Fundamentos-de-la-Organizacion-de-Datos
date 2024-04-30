program untitled;
const
	VALOR_ALTO = 'ZZZ';

type
	str = string[20];
	distribucion = record
		nombre:str;
		lanzamiento:integer;
		numeroVersion:integer;
		cantDesarrolladores:integer;
		descripcion:str;
	end;
	
	archivo = file of distribucion;
	
procedure leer (var arch:archivo; var dato:distribucion);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.nombre := VALOR_ALTO;
end;

procedure existeDistribucion (var arch:archivo; nombre:str; var existe:boolean);
var
	d:distribucion;
begin
	reset(arch);
	leer(arch,d);
	while (d.nombre <> VALOR_ALTO) and (not existe) do begin
		if (d.nombre = nombre) then
			existe:= true;
		leer(arch,d);
	end;
	close(arch);
end;

procedure altaDistribucion (var arch:archivo);
var
	existe:boolean;
	pos:integer;
	d,regACargar,aux:distribucion;
begin
	existe:= false;
	write('Ingrese nombre de distribucion a dar de alta: ');readln(regACargar.nombre);
	existeDistribucion(arch,regACargar.nombre,existe);
	
	if (existe) then writeln('Ya existe distribucion!')
	else begin
		regACargar.cantDesarrolladores := 100;
		regACargar.numeroVersion := 10;
		regACargar.descripcion:= 'XXX';
		regACargar.lanzamiento:= 2000;
		reset(arch);
		leer(arch,d);
		if (d.cantDesarrolladores = 0) then begin
			seek(arch,filesize(arch));

			write(arch,regACargar);
		end
		else begin
			pos:= d.cantDesarrolladores * -1;
			seek(arch,pos);
			read(arch,aux);
			seek(arch,filepos(arch)-1);
			write(arch,regACargar);
			seek(arch,0);
			write(arch,aux);
		end;
		close(arch);
	end;
end;


procedure bajaDistribucion (var arch:archivo);
var
	nombre:str;
	d,head:distribucion;
	posEncontre,posNeg:integer;
	existe:boolean;
begin
	existe:=false;
	write('Ingrese distribucion a eliminar: ');readln(nombre);
	existeDistribucion(arch,nombre,existe);
	if (not existe) then writeln('Distribucion no existe!')
	else begin
		reset(arch);
		leer(arch,d);
		head := d;
		while (d.nombre <> VALOR_ALTO) do begin
			if (d.nombre = nombre) then begin
				posEncontre := filepos(arch) - 1;
				posNeg := posEncontre * -1;
				d.cantDesarrolladores := posNeg;
				seek(arch,posEncontre);
				write(arch,head);
				seek(arch,0);
				write(arch,d);
				head := d;
			end;
			leer(arch,d);
			
		end;
		close(arch);
	end;
end;


procedure menu (var arch:archivo);
	procedure cargarMaestro (var arch:archivo);
	var
		d:distribucion;
	begin
		rewrite(arch);
		with d do begin
			cantDesarrolladores:= 0;
			nombre:= 'HEAD';
			lanzamiento := -999;
			numeroVersion := -999;
			descripcion:= 'XXX';
			write(arch,d);
			write ('NOMBRE: '); readln (nombre);
			while (nombre <> VALOR_ALTO) do begin
				write ('CANTIDAD DE DEVELOPERS: '); readln (cantDesarrolladores);
				lanzamiento := 2000;
				numeroVersion := 10;
				descripcion:= 'XXX';

				write(arch,d);
				writeln();
				write ('NOMBRE: '); readln (nombre);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirMaestro(var arch:archivo);
	var
		d:distribucion;
	begin
		reset(arch);
		leer(arch,d);
		while (d.nombre <> VALOR_ALTO) do begin
			writeln('NOMBRE: ',d.nombre);
			writeln('CANTIDAD DESARROLLADORES: ',d.cantDesarrolladores);
			writeln('-------------');
			leer(arch,d);
		end;
		close(arch);
	end;
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Imprimir maestro');
		writeln('3-Alta distribucion');
		writeln('4-Baja distribucion');
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
			3: altaDistribucion(arch);
			4: bajaDistribucion(arch);
		end;
		mostrarOpciones(op);
	end;
end;
	
var
	arch:archivo;
BEGIN
	assign(arch,'maestroEJ8');
	menu(arch);
END.
