program untitled;

type
	celular = record
		codigo:integer;
		nombre:string[12];
		descripcion:string[20];
		marca:string[12];
		precio:real;
		stockMin:integer;
		stockDispo:integer;
	end;
	
	archivo = file of celular;
	
procedure cargarFile (var arch:archivo);
var
	cel:celular;
begin
	write('Codigo: ');readln(cel.codigo);
	while (cel.codigo <> 999) do begin
		write('Nombre: ');readln(cel.nombre);
		write('Descripcion: ');readln(cel.descripcion);
		write('Marca: ');readln(cel.marca);
		write('Precio: ');readln(cel.precio);
		write('Stock min: ');readln(cel.stockMin);
		write('Stock dispo: ');readln(cel.stockDispo);
		writeln;
		write(arch,cel);
		write('Codigo: ');readln(cel.codigo);
	end;
	close(arch);
end;	

procedure listarStockMin (var arch:archivo);
var
	cel:celular;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,cel);
		if (cel.stockDispo < cel.stockMin) then begin
			writeln('Codigo: ',cel.codigo);
			writeln('Marca: ',cel.marca);
			writeln('Nombre: ',cel.nombre);
			writeln('Precio: ',cel.precio);
			writeln();
		end;
	end;
	close(arch);
end;

procedure listarDescripcion (var arch:archivo);
var
	cel:celular;
	cadena:string;
begin
	reset(arch);
	writeln('Ingrese cadena: ');readln(cadena);
	while (not EOF(arch)) do begin
		read(arch,cel);
		if (cadena = cel.descripcion) then begin
			writeln('Codigo: ',cel.codigo);
			writeln('Marca: ',cel.marca);
			writeln('Nombre: ',cel.nombre);
			writeln('Precio: ',cel.precio);
		end;
	end;
	close(arch);
end;

var
	arch:archivo;
	
	path:string;
BEGIN
	{'C:\Users\Julian\Desktop\FOD\celulares.txt'}
	write('Ingrese el nombre del archivo: ');readln(path);
	assign(arch,path);
	rewrite(arch);
	
	cargarFile(arch); //a
	writeln('-----LISTAR STOCK MIN------');
	listarStockMin(arch); //b 
	writeln('-----LISTAR DESCRIPCION NO VACIA------');
	listarDescripcionVacia(arch); //c
END.
