program untitled;
const
	N = 3; //100
	VALOR_ALTO = 9999;
type
	str = string[20];
	emision = record	
		fecha:integer;
		codSeminario:integer;
		nombreSeminario:str;
		descripcion:str;
		precio:real;
		ejemplaresDisponibles:integer;
		ejemplaresVendidos:integer;
	end;
	
	regDetalle = record
		fecha:integer;
		codSeminario:integer;
		ejemplaresVendidos:integer;
	end;
	
	archMaestro = file of emision;
	archDetalle = file of regDetalle;
	
	vDetalles = array [1..N] of archDetalle;
	vRegistros = array [1..N] of regDetalle;
	
procedure actualizarMaestro (var maestro:archMaestro; var v:vDetalles);
	procedure leer (var arch:archDetalle; var dato:regDetalle);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.fecha := VALOR_ALTO;
	
	end;
	procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:regDetalle);
	var	
		i,indiceMin:integer;
	begin
		min.fecha := VALOR_ALTO; min.codSeminario := VALOR_ALTO;
		for i:= 1 to N do begin
			if (vReg[i].fecha < min.fecha) then begin
				min := vReg[i];
				indiceMin := i;
			end
			else 
				if (vReg[i].fecha = min.fecha) then
					if (vReg[i].codSeminario < min.codSeminario) then begin
						min := vReg[i];
						indiceMin := i;
					end;
		end;
		leer(v[indiceMin],vReg[indiceMin]);
	end;
var
	vReg:vRegistros;
	min:regDetalle;
	regMaestro:emision;
	i,fechaAct,codAct:integer;
begin
	for i:= 1 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	reset(maestro);
	minimo(v,vReg,min);
	while (min.fecha <> VALOR_ALTO) do begin
		read(maestro,regMaestro); 
		while (min.fecha <> regMaestro.fecha) and (min.codSeminario <> regMaestro.codSeminario) do 
			read(maestro,regMaestro);
		fechaAct := min.fecha;
		codAct := min.codSeminario;
		while (fechaAct = min.fecha) and (codAct = min.codSeminario) do begin
			regMaestro.ejemplaresDisponibles := regMaestro.ejemplaresDisponibles - min.ejemplaresVendidos;
			regMaestro.ejemplaresVendidos := regMaestro.ejemplaresVendidos + min.ejemplaresVendidos;
			minimo(v,vReg,min);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regMaestro);
	end;
	for i:= 1 to N do begin
		close(v[i]);
	end;
	close(maestro);
end;

procedure masVentasYmenosVentas (var v:vDetalles); 
var
	venta:regDetalle;
	codMin,codMax,fechaMin,fechaMax,min,max,i:integer;
begin
	max:=-1; min:=VALOR_ALTO;
	for i:= 1 to N do begin
		reset(v[i]);
		while (not EOF(v[i])) do begin
			read(v[i],venta);
			if (venta.ejemplaresVendidos < min) then begin
				codMin := venta.codSeminario;
				fechaMin := venta.fecha;
				min := venta.ejemplaresVendidos;
			end;
			if (venta.ejemplaresVendidos > max) then begin
				codMax := venta.codSeminario;
				fechaMax := venta.fecha;
				max := venta.ejemplaresVendidos;
			end;
		end;
		close(v[i]);
	end;
	writeln('EL SEMINARIO QUE TUVO MENOS VENTAS ES EL: ',codMin,' FECHA: ',fechaMin,' VENDIO: ',min);
	writeln('EL SEMINARIO QUE TUVO MAS VENTAS ES EL: ',codMax,' FECHA: ',fechaMax,' VENDIO: ',max);
end;
	
	
procedure menu (var maestro:archMaestro; var v:vDetalles);
	procedure cargarMaestro(var arch:archMaestro);
	var
		info:emision;
	begin
		rewrite(arch);
		with info do begin
			write('FECHA: ');readln(fecha);
			while (fecha <> 0) do begin
				write('CODIGO DE SEMINARIO: ');readln(codSeminario);
				write('PRECIO: ');readln(precio);
				write('EJEMPLARES DISPONIBLES: ');readln(ejemplaresDisponibles);
				write('EJEMPLARES VENDIDOS: ');readln(ejemplaresVendidos);
				nombreSeminario := 'X';
				descripcion:= 'Y';
				write(arch,info);
				writeln();
				write('FECHA: ');readln(fecha);
			end;
		end;
		close(arch);
	end;
	
	procedure cargarDetalles(var v:vDetalles);
		procedure cargarDetalle(var arch:archDetalle);
		var
			info:regDetalle;
		begin
			with info do begin
				write('FECHA: ');readln(fecha);
				while (fecha <> 0) do begin
					write('CODIGO DE SEMINARIO: ');readln(codSeminario);
					write('EJEMPLARES VENDIDOS: ');readln(ejemplaresVendidos);
					write(arch,info);
					writeln();
					write('FECHA: ');readln(fecha);
				end;
			end;
		end;
	var
		i:integer;
	begin
		for i:= 1 to N do begin
			writeln('-----DETALLE ',i,' ------');
			rewrite(v[i]);
			cargarDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure imprimirMaestro(var arch:archMaestro);
	var
		info:emision;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,info);
			writeln('Fecha: ',info.fecha);
			writeln('Codigo de seminario: ',info.codSeminario);
			writeln('Ejemplares disponibles: ',info.ejemplaresDisponibles);
			writeln('Ejemplares vendidos: ',info.ejemplaresVendidos);
			writeln();
		end;
		close(arch);
	end;
	
	procedure imprimirDetalles(var v:vDetalles);
		procedure imprimirDetalle (var arch:archDetalle);
		var
			info:regDetalle;
		begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('Fecha: ',info.fecha);
				writeln('Codigo de seminario: ',info.codSeminario);
				writeln('Ejemplares vendidos: ',info.ejemplaresVendidos);
				writeln();
			end;
		end;
	var
		i:integer;
	begin
		for i:= 1 to N do begin
			writeln('-----DETALLE ',i,' ------');
			reset(v[i]);
			imprimirDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalles');
		writeln('5-Actualizar maestro');
		writeln('6-Informo max y min en detalles');
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
			2: cargarDetalles(v);
			3: imprimirMaestro(maestro);
			4: imprimirDetalles(v);
			5: actualizarMaestro(maestro,v);
			6: masVentasYmenosVentas(v);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;		
var
	maestro:archMaestro;
	vDet:vDetalles;
BEGIN
	assign(vDet[1],'detalle1EJ15');
	assign(vDet[2],'detalle2EJ15');
	assign(vDet[3],'detalle3EJ15');
	assign(maestro,'maestroEJ15');
	menu(maestro,vDet);
END.

