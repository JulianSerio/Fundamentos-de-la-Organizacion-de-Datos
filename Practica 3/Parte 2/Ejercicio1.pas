program untitled;
const
	VALOR_ALTO = 9999;
type
	str = string[20];
	producto = record
		codigo:integer;
		nombre:str;
		precio:real;
		stockActual:integer;
		stockMinimo:integer;
	end;
	
	venta = record
		codigo:integer;
		cantUnidades:integer;
	end;
	
	archMaestro = file of producto;
	archDetalle = file of venta;
	
	
procedure leer (var arch:archDetalle; var dato:venta);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.codigo := VALOR_ALTO;
end;

procedure leerMaestro(var arch:archMaestro; var dato:producto);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.codigo := VALOR_ALTO;
end;


procedure actualizarMaestro (var maestro:archMaestro; var detalle:archDetalle);
var
	regDet:venta;
	regMae:producto;
begin
	reset(detalle);
	leer(detalle,regDet);
	while (regDet.codigo <> VALOR_ALTO) do begin
		reset(maestro); 
		writeln('opa');
		leerMaestro(maestro,regMae);
		while (regMae.codigo <> VALOR_ALTO) and (regDet.codigo <> regMae.codigo) do 
			leerMaestro(maestro,regMae);
		if (regDet.codigo = regMae.codigo) then begin
			regMae.stockActual := regMae.stockActual - regDet.cantUnidades;
			seek(maestro,filepos(maestro) - 1);
			write(maestro,regMae);
		end;
		close(maestro);
		leer(detalle,regDet);
	end;
	close(detalle);
end;

procedure menu (var maestro:archMaestro;var detalle:archDetalle);
	procedure cargarMaestro (var arch:archMaestro);
	var
		p:producto;
	begin
		rewrite(arch);
		with p do begin
			write ('CODIGO: '); readln (codigo);
			while (codigo <> 0) do begin
				nombre:='ZZZ';
				precio:=10;
				stockMinimo:=50;
				write ('STOCK ACTUAL: '); readln (stockActual);
				
				write(arch,p);
				writeln();
				write ('CODIGO: '); readln (codigo);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirMaestro(var arch:archMaestro);
	var
		p:producto;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,p);
			writeln('CODIGO: ',p.codigo);
			//writeln('NOMBRE: ',p.nombre);
			//writeln('PRECIO: ',p.precio);
			writeln('STOCK ACTUAL: ',p.stockActual);
			//writeln('STOCK MINIMO: ',p.stockMinimo);
			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
	procedure cargarDetalle (var arch:archDetalle);
	var
		v:venta;
	begin
		rewrite(arch);
		with v do begin
			write ('CODIGO: '); readln (codigo);
			while (codigo <> 0) do begin
				write ('UNIDADES VENDIDAS: '); readln (cantUnidades);
				write(arch,v);
				writeln();
				write ('CODIGO: '); readln (codigo);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirDetalle(var arch:archDetalle);
	var
		v:venta;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,v);
			writeln('CODIGO: ',v.codigo);
			writeln('UNIDADES VENDIDAS: ',v.cantUnidades);
			writeln('-------------');
			writeln;
		end;
		close(arch);
	end;
		
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Imprimir maestro');
		writeln('3-Cargar detalle');
		writeln('4-Imprimir detalle');
		writeln('5-Actualizar maestro');
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
			2: imprimirMaestro(maestro);
			3: cargarDetalle(detalle);
			4: imprimirDetalle(detalle);
			5: actualizarMaestro(maestro,detalle);
		end;
		mostrarOpciones(op);
	end;
end;
var
	maestro:archMaestro;
	detalle:archDetalle;
BEGIN	
	assign(maestro,'maestroEJ1');
	assign(detalle,'detalleEJ1');
	menu(maestro,detalle);
END.

