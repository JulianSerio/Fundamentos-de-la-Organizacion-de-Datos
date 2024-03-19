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
	
procedure imprimirCelular (cel:celular);
begin
	with cel do begin
		writeln('Codigo: ',cel.codigo);
		writeln('Nombre: ',cel.nombre);
		writeln('Descripcion: ',cel.descripcion);
		writeln('Marca: ',cel.marca);
		writeln('Precio: ',cel.precio:0:2);
		writeln('Stock minimo: ',cel.stockMin);
		writeln('Stock disponible: ',cel.stockDispo);
		writeln('---------');
	end;
end;

procedure cargarFile (var arch:archivo; var archivoTexto:Text);
var
	cel:celular;
begin
	reset(archivoTexto);
	rewrite(arch);
	while (not EOF(archivoTexto)) do begin
		readln(archivoTexto,cel.codigo,cel.precio,cel.marca);
		readln(archivoTexto,cel.stockDispo,cel.stockMin,cel.descripcion);
		readln(archivoTexto,cel.nombre);
		write(arch,cel);
	end;
	close(archivoTexto);
	close(arch);
end;

procedure listarStockMin (var arch:archivo);
var
	cel:celular;
begin
	reset(arch);
	writeln;
	while (not EOF(arch)) do begin
		read(arch,cel);
		if (cel.stockDispo < cel.stockMin) then begin
			imprimirCelular(cel);
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
	writeln;
	writeln('Ingrese cadena:');readln(cadena);
	cadena := ' '+cadena;
	while (not EOF(arch)) do begin
		read(arch,cel);
		if (cel.descripcion = cadena) then begin
			imprimirCelular(cel);
		end;
	end;
	close(arch);
end;

procedure cargarArchivo(var arch:archivo;var archivoTexto:Text);
var
	cel:celular;
begin
	rewrite(archivoTexto);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,cel);
		writeln(archivoTexto,cel.codigo,cel.precio:0:2,cel.marca);
		writeln(archivoTexto,cel.stockDispo,cel.stockMin,cel.descripcion);
		writeln(archivoTexto,cel.nombre);
	end;
	close(arch);
	close(archivoTexto);
end;

procedure agregarCelulares(var arch:archivo);
var
	rta:string;
	cel:celular;
begin
	reset(arch);
	writeln('¿Desea agregar un celular?');readln(rta);
	while (rta = 'si') do begin
		write('INGRESE CODIGO: ');readln(cel.codigo);
		write('INGRESE NOMBRE: ');readln(cel.nombre);
		write('INGRESE DESCRIPCION: ');readln(cel.descripcion);
		write('INGRESE MARCA: ');readln(cel.marca);
		write('INGRESE PRECIO: ');readln(cel.precio);
		write('INGRESE STOCK MINIMO: ');readln(cel.stockMin);
		write('INGRESE STOCK DISPONIBLE: ');readln(cel.stockDispo);
		seek(arch,filesize(arch));
		write(arch,cel); //
		writeln('¿Desea agregar un celular?');readln(rta);
	end;
	close(arch);
end;

procedure modificarStock (var arch:archivo);
var
	stockNuevo:integer;
	cel:celular;
	esta:boolean;
	nombre:string;
begin
	write('INGRESE NOMBRE A BUSCAR: ');readln(nombre);
	write('INGRESE STOCK A ACTUALIZAR ');readln(stockNuevo);
	esta:=false;
	reset(arch);
	while (not EOF(arch)) and (esta = false) do begin
		read(arch,cel);
		if (cel.nombre = nombre) then begin
			esta:= true;
			cel.stockDispo := stockNuevo;
			seek(arch,filepos(arch) - 1); //filepos devuelve la pos del sig
			write(arch,cel);
		end;
	end;
	close(arch);
end;

procedure exportarContenidoSinStock(var arch:archivo; var archivoSinStock:Text);
var
	cel:celular;
begin
	rewrite(archivoSinStock);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,cel);
		if (cel.stockDispo = 0) then begin
			writeln(archivoSinStock,cel.codigo,cel.precio:0:0,cel.marca);
			writeln(archivoSinStock,cel.stockDispo,cel.stockMin,cel.descripcion);
			writeln(archivoSinStock,cel.nombre);
		end;
	end;
	close(arch);
	close(archivoSinStock);
end;

procedure menu (var arch:archivo; var archCarga:Text; var celulares:Text; var archivoSinStock:Text);
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Crear archivo');
		writeln('2-Listar celulares con stock menor al minimo');
		writeln('3-Listar celulares descripcion especifica');
		writeln('4-Cargar archivo celulares.txt');
		writeln('5-Imprimir contenido');
		writeln('6-Anadir celulares');
		writeln('7-Modificar stock');
		writeln('8-Exportar contenido a SinStock.txt');
		writeln('0-Salir');
		writeln('Ingrese opcion:');
		readln(op);
	end;
	
	procedure imprimirArchivo(var arch:archivo);
	var
		cel:celular;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,cel);
			imprimirCelular(cel);
		end;
		close(arch);
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarFile(arch,archCarga);
			2: listarStockMin(arch);
			3: listarDescripcion(arch);
			4: cargarArchivo(arch,celulares);
			5: imprimirArchivo(arch);
			6: agregarCelulares(arch);
			7: modificarStock(arch);
			8: exportarContenidoSinStock(arch,archivoSinStock);
		end;
		mostrarOpciones(op);
	end;
end;

var
	arch:archivo;
	archivoTexto:Text;
	archivoSinStock:Text;
	nom:string;
	celulares:Text;
BEGIN
	write('Ingrese nombre: ');readln(nom);
	assign(archivoTexto,'celulares.txt');
	assign(celulares,'celulares2.txt');
	assign(archivoSinStock,'SinStock.txt');
	assign(arch,nom);
	menu(arch,archivoTexto,celulares,archivoSinStock);
END.
