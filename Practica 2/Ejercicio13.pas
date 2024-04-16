program untitled;
const 
	N = 1;
	VALOR_ALTO = 'ZZZ';
type	
	rango = 0..N;
	str = string[20];
	vuelo = record
		destino:str;
		horaSalida:integer;
		fecha:integer;
		asientos:integer;
	end;
	
	lista = ^nodo;
	nodo = record
		elem:vuelo;
		sig:lista;
	end;
	
	archivo = file of vuelo;
	
	vDetalles = array [rango] of archivo;
	vRegistros = array [rango] of vuelo;

procedure actualizarMaestro (var maestro:archivo; var v:vDetalles; var L:lista);
	procedure agregar (var L:lista; dato:vuelo);
	var
		aux:lista;
	begin
		new(aux);
		aux^.elem:= dato;
		aux^.sig:=L;
		L:=aux;
	end;
	procedure leer(var arch:archivo; var dato:vuelo);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else  dato.destino := VALOR_ALTO;
	end;
	procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:vuelo);
	var
		i,indiceMin:integer;
	begin
		min.fecha:= 9999; min.horaSalida := 9999; min.destino := 'ZZZ';
		for i:= 0 to N do begin
			if (vReg[i].destino < min.destino) then begin
				indiceMin:=i;
				min:= vReg[i];
			end
			else 
				if (vReg[i].destino = min.destino) then 
					if (vReg[i].fecha < min.fecha) then begin
						indiceMin:=i;
						min:= vReg[i];
					end
					else 
						if (vReg[i].fecha = min.fecha) then 
							if (vReg[i].horaSalida < min.horaSalida) then begin
								indiceMin:=i;
								min:= vReg[i];
							end;					
		end;
		leer(v[indiceMin],vReg[indiceMin]);
	end;
var
	min:vuelo;
	vReg:vRegistros;
	regMaestro:vuelo;
	i,fechaAct:integer;
	salidaAct:integer;
	destinoAct:str;
	asientos:integer;
begin
	for i:= 0 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	write('Ingrese la cantidad: ');readln(asientos);
	reset(maestro);
	minimo(v,vReg,min);
	while (min.destino <> 'ZZZ') do begin
		read(maestro,regMaestro);
		while(regMaestro.destino <> min.destino) and (regMaestro.fecha <> min.fecha) and (regMaestro.horaSalida <> min.horaSalida)  do begin
			if (asientos < regMaestro.asientos) then
				agregar(L,regMaestro);
			read(maestro,regMaestro);
		end;
		salidaAct:= min.horaSalida;
		fechaAct:= min.fecha;
		destinoAct:= min.destino;
		while (destinoAct = min.destino) and (fechaAct = min.fecha) and (salidaAct = min.horaSalida) do begin
			regMaestro.asientos := regMaestro.asientos - min.asientos;
			minimo(v,vReg,min);
		end;
		if (asientos < regMaestro.asientos) then
			agregar(L,regMaestro);
		seek(maestro,filePos(maestro)-1);
		write(maestro,regMaestro);
	end;
	for i:= 0 to N do begin
		close(v[i]);
	end;
	while (not EOF(maestro)) do begin 
		read(maestro,regMaestro);
		if (asientos < regMaestro.asientos) then
				agregar(L,regMaestro);
	end;
	close(maestro);
end;

procedure menu (var maestro:archivo; var v:vDetalles);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalles');
		writeln('5-Actualizar maestro');
		writeln('6-Imprimir lista');
		writeln('0-Finalizar');
		readln(op);
	end;
	
	procedure imprimirMaestro(var arch:archivo);
	var
		v:vuelo;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,v);
			writeln('Destino: ',v.destino);
			writeln('Hora de salida: ',v.horaSalida);
			writeln('Fecha: ',v.fecha);
			writeln('Asientos: ',v.asientos);
			writeln();
		end;
		close(arch);
	end;
	procedure imprimirDetalles(var v:vDetalles);
	var
		i:integer;
	begin
		for i:= 0 to N do begin
			writeln('-----DETALLE ',i,' ------');
			imprimirMaestro(v[i]);
		end;
	end;
	
	procedure cargarMaestro(var arch:archivo);
	var
		v:vuelo;
	begin
		rewrite(arch);
		with v do begin
			write('DESTINO: ');readln(destino);
			while (destino <> '0') do begin
				write('HORA SALIDA: ');readln(horaSalida);
				write('FECHA : ');readln(fecha);	
				write('ASIENTOS: ');readln(asientos);
				write(arch,v);
				writeln();
				write('DESTINO: ');readln(destino);
			end;
		end;
		close(arch);
	end;	
	procedure cargarDetalles(var v:vDetalles);
		procedure cargarDetalle(var arch:archivo);
		var
			vu:vuelo;
		begin
			with vu do begin
				write('DESTINO: ');readln(destino);
				while (destino <> '0') do begin
					write('HORA SALIDA: ');readln(horaSalida);
					write('FECHA : ');readln(fecha);	
					write('ASIENTOS: ');readln(asientos);
					write(arch,vu);
					writeln();
					write('DESTINO: ');readln(destino);
				end;
			end;
		end;
	var
		i:integer;
	begin
		for i:= 0 to N do begin
			rewrite(v[i]);
			writeln('-----DETALLE ',i,' ------');
			cargarDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure imprimirLista (L:lista);
	begin
		while (L <> nil) do begin
			writeln('Hora de salida: ',L^.elem.horaSalida);
			writeln('Destino: ',L^.elem.destino);
			writeln('Fecha: ',L^.elem.fecha);
			writeln('Asientos: ',L^.elem.asientos);
			writeln();
			L:=L^.sig;
		end;
	end;
var
	op:integer;
	L:lista;
begin
	L:=nil;
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of
			1: cargarMaestro(maestro);
			2: cargarDetalles(v);
			3: imprimirMaestro(maestro);
			4: imprimirDetalles(v);
			5: actualizarMaestro(maestro,v,L);
			6: imprimirLista(L);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;
var
	maestro:archivo;
	v:vDetalles;
BEGIN
	assign(maestro,'maestroEJ13');
	assign(v[0],'detalle1EJ13');
	assign(v[1],'detalle2EJ13');
	menu(maestro,v);
END.

