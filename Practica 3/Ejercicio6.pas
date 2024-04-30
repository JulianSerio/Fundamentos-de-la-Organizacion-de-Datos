program untitled;
const
	VALOR_ALTO = 999;
type 
	str = string[20];
	prendaMaestro = record
		cod:integer;
		descripcion:str;
		colores:str;
		tipo:str;
		stock:integer;
		precio:real;
	end;
	
	prendaDetalle = record
		cod:integer;
	end;
	
	archMaestro = file of prendaMaestro;
	archDetalle = file of prendaDetalle;

procedure actualizarStock (var maestro:archMaestro; var detalle:archDetalle);
	procedure leerDetalle (var arch:archDetalle; var dato:prendaDetalle);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.cod := VALOR_ALTO;
	end;
	
	procedure leerMaestro (var arch:archMaestro; var dato:prendaMaestro);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.cod := VALOR_ALTO;
	end;
var
	regDet:prendaDetalle;
	regMae:prendaMaestro;
begin
	reset(maestro);
	leerMaestro(maestro,regMae); //leo el primer registro
	while (regMae.cod <> VALOR_ALTO) do begin //mientras no sea un valor alto
		reset(detalle); //abro el detalle en cada reg del maestro
		leerDetalle(detalle,regDet); //leo detalle 
		while (regDet.cod <> VALOR_ALTO) do begin //mientras no sea un valor alto
			if (regDet.cod = regMae.cod) then begin //compruebo que sean iguales
				regMae.stock := regMae.stock * -1;
				seek(maestro,filepos(maestro)-1);
				write(maestro,regMae);
			end;
			leerDetalle(detalle,regDet); //vuelvo a leer el detalle
		end;
		leerMaestro(maestro,regMae);
		close(detalle);
	end;
	close(maestro);
end;

procedure compactarMaestro (var maestro:archMaestro; var maestroNew:archMaestro);
var
	p:prendaMaestro;
begin
	rewrite(maestroNew);
	reset(maestro);

	while (not EOF(maestro)) do begin
		read(maestro,p);
		if (p.stock > 0) then begin
			write(maestroNew,p);
		end;
	end;
	close(maestro);
	close(maestroNew);
end;	
	
procedure menu (var maestro:archMaestro; var detalle:archDetalle; var maestroNew:archMaestro);
	procedure cargarMaestro (var arch:archMaestro);
	var
		p:prendaMaestro;
	begin
		rewrite(arch);
		with p do begin
			write ('CODIGO: '); readln (cod);
			while (cod <> 0) do begin
				//write ('DESCRIPCION: '); readln (descripcion);
				//write ('COLORES: '); readln (colores);
				//write ('TIPO: '); readln (tipo);
				descripcion:='X';
				colores:='Y';
				tipo:='Z';
				
				write ('STOCK: '); readln (stock);
				write ('PRECIO: '); readln (precio);
				write(arch,p);
				writeln();
				write ('CODIGO: '); readln (cod);
			end;	
		end;
		close(arch);
	end;
	
	procedure cargarDetalle (var arch:archDetalle);
	var
		p:prendaDetalle;
	begin
		rewrite(arch);
		with p do begin
			write ('CODIGO: '); readln (cod);
			while (cod <> 0) do begin
				write(arch,p);
				writeln();
				write ('CODIGO: '); readln (cod);
			end;	
		end;
	
	end;

	procedure imprimirMaestro(var arch:archMaestro);
	var
		p:prendaMaestro;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,p);
			writeln('CODIGO: ',p.cod);
			//writeln('DESCRIPCION: ',p.descripcion);
			//writeln('COLORES: ',p.colores);
			//writeln('TIPO: ',p.tipo);
			writeln('STOCK: ',p.stock);
			writeln('PRECIO: ',p.precio:2:0);
			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
	
	procedure imprimirDetalle(var arch:archDetalle);
	var
		p:prendaDetalle;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,p);
			writeln('CODIGO: ',p.cod);
			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
	
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalle');
		writeln('3-Imprimir Maestro');
		writeln('4-Imprimir Detalle');
		writeln('5-Actualizar stock');
		writeln('6-Compactar maestro');
		writeln('7-Imprimir maestro new');
		writeln('0-Finalizar');
		readln(op);
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarMaestro(maestro);
			2: cargarDetalle(detalle);
			3: imprimirMaestro(maestro);
			4: imprimirDetalle(detalle);
			5: actualizarStock(maestro,detalle);
			6: compactarMaestro(maestro,maestroNew);
			7: imprimirMaestro(maestroNew);
		end;
		mostrarOpciones(op);
	end;
end;

var	
	maestro,maestroNew:archMaestro;
	detalle:archDetalle;
BEGIN
	assign(maestro,'maestroEJ6');
	assign(detalle,'detalleEJ6');
	assign(maestroNew,'maestroNewEJ6');

	menu(maestro,detalle,maestroNew);
	
	
END.

