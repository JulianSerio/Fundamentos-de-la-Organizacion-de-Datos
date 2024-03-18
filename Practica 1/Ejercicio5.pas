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
	archivoTexto:text;
begin
	assign(archivoTexto,'C:\Users\Julian\Desktop\FOD\celulares.txt');
	reset(archivoTexto);
	
	while (not EOF(archivoTexto)) do begin
		read(archivoTexto,cel);
		write(arch,cel);
	end;
	
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

procedure listarDescripcionVacia (var arch:archivo);
var
	cel:celular;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,cel);
		if (cel.descripcion <> '') then begin
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

BEGIN

	
	cargarFile(arch); //a
	writeln('-----LISTAR STOCK MIN------');
	listarStockMin(arch); //b 
	writeln('-----LISTAR DESCRIPCION NO VACIA------');
	listarDescripcionVacia(arch); //c
END.

