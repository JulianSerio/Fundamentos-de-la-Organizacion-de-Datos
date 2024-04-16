program ejercicio16;
const
	N = 3; //10
	VALOR_ALTO = 9999;
type
	str = string[20];
	moto = record
		cod:integer;
		nombre:str;
		descripcion:str;
		modelo:str;
		marca:str;
		stock:integer;
	end;
	
	venta = record
		cod:integer;
		precio:integer;
		fecha:integer;
	end;
	
	archMaestro = file of moto;
	archDetalle = file of venta;
	
	vDetalles = array [1..N] of archDetalle;
	vRegistros = array [1..N] of venta;
	
procedure actualizarMaestro (var v:vDetalles; var maestro:archMaestro);
	procedure leer(var arch:archDetalle; var dato:venta);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.cod := VALOR_ALTO;
	end;
	procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:venta);
	var
		i,indiceMin:integer;
	begin
		min.cod := VALOR_ALTO;indiceMin:=VALOR_ALTO;
		for i:= 1 to N do begin
			if (vReg[i].cod < min.cod) then begin
				indiceMin := i;
				min:= vReg[i];
			end;
		end;
		if (indiceMin <> VALOR_ALTO) then
			leer(v[indiceMin],vReg[indiceMin]);
	end;
var
	vReg:vRegistros;
	min:venta;
	codActual,i,count,max,motoMasVendida:integer;
	regMaestro:moto;

begin
	max:= -1;
	for i:= 1 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	reset(maestro);
	minimo(v,vReg,min);
	while (min.cod <> VALOR_ALTO) do begin
		read(maestro,regMaestro);
		while (regMaestro.cod <> min.cod) do 
			read(maestro,regMaestro);
		codActual := min.cod;
		count:=0;
		while (codActual = min.cod) do begin
			regMaestro.stock := regMaestro.stock - 1;
			count:= count + 1;
			minimo(v,vReg,min);
		end;
		if (count > max) then begin
			max:= count;
			motoMasVendida:= codActual;
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regMaestro);
	end;
	for i:= 1 to N do begin
		close(v[i]);
	end;
	close(maestro);
	writeln('EL CODIGO DE LA MOTO MAS VENDIDA ES: ',motoMasVendida,' CON ',max,' VENTAS!');
end;
	
procedure menu (var maestro:archMaestro; var v:vDetalles);
	procedure cargarMaestro(var arch:archMaestro);
	var
		m:moto;
	begin
		rewrite(arch);
		with m do begin
			write('CODIGO: ');readln(cod);
			while (cod <> 0) do begin
				nombre:= 'X';
				descripcion:= 'Y';
				modelo:= 'Z';
				write('STOCK: ');readln(stock);
				write(arch,m);
				writeln();
				write('CODIGO: ');readln(cod);
			end;
		end;
		close(arch);
	end;
	
	procedure cargarDetalles(var v:vDetalles);
		procedure cargarDetalle(var arch:archDetalle);
		var
			v:venta;
		begin
			with v do begin
				write('CODIGO: ');readln(cod);
				while (cod <> 0) do begin
					precio:=0;
					fecha:=0;
					write(arch,v);
					writeln();
					write('CODIGO: ');readln(cod);
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
		m:moto;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,m);
			writeln('Codigo:',m.cod);
			writeln('Stock:',m.stock);
			writeln();
		end;
		close(arch);
	end;
	
	procedure imprimirDetalles(var v:vDetalles);
		procedure imprimirDetalle (var arch:archDetalle);
		var
			v:venta;
		begin
			while (not EOF(arch)) do begin
				read(arch,v);
				writeln('Codigo:',v.cod);
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
			5: actualizarMaestro(v,maestro);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;		
var
	vDet:vDetalles;
	maestro:archMaestro;
BEGIN
	assign(vDet[1],'detalle1EJ16');
	assign(vDet[2],'detalle2EJ16');
	assign(vDet[3],'detalle3EJ16');
	assign(maestro,'maestroEJ16');
	menu(maestro,vDet);
END.

