program untitled;
const 
	N = 2; //10;
	VALOR_ALTO = 9999;
type
	str = string[20];
	registroMaestro = record
		codProvincia:integer;
		nombreProvincia:str;
		codLocalidad:integer;
		nombreLocalidad:str;
		sinLuz:integer;
		sinGas:integer;
		deChapa:integer;
		sinAgua:integer;
		sinSanitarios:integer;
	end;
	
	registroDetalle = record
		codProvincia:integer;
		codLocalidad:integer;
		conLuz:integer;
		construidas:integer;
		conAgua:integer;
		conGas:integer;
		entregaSanitarios:integer;
	end;
	
	archMaestro = file of registroMaestro;
	archDetalle = file of registroDetalle;
	
	vDetalles = array [1..N] of archDetalle;
	vRegistros = array [1..N] of registroDetalle;
	
procedure actualizarMaestro (var maestro:archMaestro; var v:vDetalles);
	procedure leer (var arch:archDetalle; var dato:registroDetalle);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.codProvincia := VALOR_ALTO;
	end;
	procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:registroDetalle);
	var
		i,indiceMin:integer;
	begin
		min.codProvincia := VALOR_ALTO; min.codLocalidad := VALOR_ALTO;
		for i:= 1 to N do begin
			if (vReg[i].codProvincia < min.codProvincia) then begin
				min:=vReg[i];
				indiceMin:=i;
			end
			else 
				if (vReg[i].codProvincia = min.codProvincia) then
					if (vReg[i].codLocalidad < min.codLocalidad) then begin
						min:=vReg[i];
						indiceMin:=i;	
					end;
		end;
		leer(v[indiceMin],vReg[indiceMin]);
	end;
var
	min:registroDetalle;
	vReg:vRegistros;
	regMaestro:registroMaestro;
	i,provActual,locActual:integer;
begin
	for i:= 1 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	reset(maestro);
	minimo(v,vReg,min);
	while (min.codProvincia <> VALOR_ALTO) do begin
		read(maestro,regMaestro);
		while (regMaestro.codProvincia <> min.codProvincia) and (regMaestro.codLocalidad <> min.codLocalidad) do 
			read(maestro,regMaestro);
		provActual:= min.codProvincia;
		while (provActual = min.codProvincia) do begin
			locActual:=min.codLocalidad;
			while (provActual = min.codProvincia) and (locActual = min.codLocalidad) do begin
				regMaestro.sinLuz := regMaestro.sinLuz - min.conLuz;
				regMaestro.sinGas := regMaestro.sinGas - min.conGas;
				regMaestro.sinAgua := regMaestro.sinAgua - min.conAgua;
				regMaestro.sinSanitarios := regMaestro.sinSanitarios - min.entregaSanitarios;
				regMaestro.deChapa := regMaestro.deChapa - min.construidas;
				minimo(v,vReg,min);
			end;
			seek(maestro,filepos(maestro)-1);
			write(maestro,regMaestro);
		end;
	end;
	for i:= 1 to N do begin
		close(v[i]);
	end;
	close(maestro);
end;

procedure informarLocalidades (var maestro:archMaestro);
var
	info:registroMaestro;
	cant:integer;
begin
	cant:=0;
	reset(maestro);
	while (not EOF(maestro)) do begin
		read(maestro,info);
		if (info.deChapa = 0) then 
			cant:= cant +1;
	end;
	close(maestro);
	writeln('La cantidad de localidades sin casas de chapa es: ',cant);
end;


procedure menu (var maestro:archMaestro; var v:vDetalles);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalles');
		writeln('5-Actualizar maestro');
		writeln('6-Informo localidades');
		writeln('0-Finalizar');
		readln(op);
	end;
	
	procedure imprimirMaestro(var arch:archMaestro);
	var
		info:registroMaestro;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,info);
			writeln('Codigo provincia: ',info.codProvincia);
			writeln('Codigo localidad: ',info.codLocalidad);
			writeln('Viviendas sin luz: ',info.sinLuz);
			writeln('Viviendas sin gas: ',info.sinGas);
			writeln('Viviendas sin agua: ',info.sinAgua);
			writeln('Viviendas sin sanitarios: ',info.sinSanitarios);
			writeln('Viviendas de chapa: ',info.deChapa);
			writeln();
		end;
		close(arch);
	end;
	procedure imprimirDetalle (var arch:archDetalle);
	var
		info:registroDetalle;
	begin
		while (not EOF(arch)) do begin
			read(arch,info);
			writeln('Codigo provincia: ',info.codProvincia);
			writeln('Codigo localidad: ',info.codLocalidad);
			writeln('Viviendas con luz: ',info.conLuz);
			writeln('Viviendas con gas: ',info.conGas);
			writeln('Viviendas con agua: ',info.conAgua);
			writeln('Viviendas construidos: ',info.construidas);
			writeln('Entrega de sanitarios: ',info.entregaSanitarios);
			writeln();
		end;
	end;
	
	procedure imprimirDetalles(var v:vDetalles);
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
	
	procedure cargarMaestro(var arch:archMaestro);
	var
		info:registroMaestro;
	begin
		rewrite(arch);
		with info do begin
			write('CODGIO DE PROVINCIA: ');readln(codProvincia);
			while (codProvincia <> 0) do begin
				nombreProvincia:='X';
				nombreLocalidad:='Y';
				write('CODIGO DE LOCALIDAD: ');readln(codLocalidad);
				write('VIVIENDAS SIN LUZ: ');readln(sinLuz);
				write('VIVIENDAS SIN GAS: ');readln(sinGas);
				write('VIVIENDAS SIN AGUA: ');readln(sinAgua);
				write('VIVIENDAS DE CHAPA: ');readln(deChapa);
				write('VIVIENDAS SIN SANITARIOS: ');readln(sinSanitarios);
				write(arch,info);
				writeln();
				write('CODGIO DE PROVINCIA: ');readln(codProvincia);
			end;
		end;
		close(arch);
	end;	
	procedure cargarDetalles(var v:vDetalles);
		procedure cargarDetalle(var arch:archDetalle);
		var
			info:registroDetalle;
		begin
			with info do begin
				write('CODIGO PROVINCIA: ');readln(codProvincia);
				while (codProvincia <> 0) do begin
					write('CODIGO LOCALIDAD: ');readln(codLocalidad);
					write('VIVIENDAS CON LUZ: ');readln(conLuz);
					write('VIVIENDAS CON GAS: ');readln(conGas);
					write('VIVIENDAS CON AGUA: ');readln(conAgua);
					write('VIVIENDAS CONSTRUIDAS: ');readln(construidas);
					write('ENTREGA DE SANITARIOS: ');readln(entregaSanitarios);
					write(arch,info);
					writeln();
					write('CODIGO PROVINCIA: ');readln(codProvincia);
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
			6: informarLocalidades(maestro);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;
var
	vDet:vDetalles;
	maestro:archMaestro;
BEGIN
	assign(vDet[1],'detalle1EJ14');
	assign(vDet[2],'detalle2EJ14');
	assign(maestro,'maestroEJ14');
	menu(maestro,vDet);
END.

