program untitled;
const 
	N = 2;//50
	VALOR_ALTO = 9999;
type
	str = string[20];
	direccion = record
		calle:integer;
		nro:integer;
		depto:integer;
		ciudad:str;
		piso:integer;
	end;

	nacimiento = record
		nroPartida:integer;
		dni:integer;
		nombreYapellido:str;
		dir:direccion;
		matriculaMedico:integer;
		nombreYapellidoMadre:str;
		nombreYapellidoPadre:str;
		dniMadre:integer;
		dniPadre:integer;
	end;
	
	fallecimiento = record
		nroPartida:integer;
		dni:integer;
		nombreYapellido:str;
		matriculaMedico:integer;
		fecha:integer;
		hora:integer;
		lugar:str;
	end;
	
	registroMaestro = record
		nroPartida:integer;
		nombreYapellido:str;
		dir:direccion;
		matriculaMedicoNacimiento:integer;
		matriculaMedicoFalleciminento:integer;
		nombreYapellidoMADRE:str;
		nombreYapellidoPADRE:str;	
		dniMadre:integer;
		dniPadre:integer;
		fallecio:boolean;
		fecha:integer;
		lugar:str;
		hora:integer;
	end;
	
	archFallecimiento = file of fallecimiento;
	archNacimiento = file of nacimiento;
	archMaestro = file of registroMaestro;
	
	vRegistroFallecimientos = array [1..N] of fallecimiento;
	vFallecimientos = array [1..N] of archFallecimiento;
	vRegistroNacimientos = array [1..N] of nacimiento;
	vNacimientos = array [1..N] of archNacimiento;

procedure crearMaestro (var vN:vNacimientos; var vF:vFallecimientos; var maestro:archMaestro);
	procedure leer(var arch:archNacimiento; var dato:nacimiento);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.nroPartida := VALOR_ALTO;
	end;
	
	procedure buscarFallecimiento (var v:vFallecimientos; var dato:fallecimiento; nroPartidaABuscar:integer);
	var
		f:fallecimiento;
		i:integer;
	begin
		for i:= 1 to N do begin
			reset(v[i]);
			while (not EOF(v[i])) do begin
				read(v[i],f);
				if (f.nroPartida = nroPartidaABuscar) then 
					dato:= f;
			end;
			close(v[i]);
		end;
	end;
	
	procedure minimo (var v:vNacimientos; var vReg:vRegistroNacimientos; var min:nacimiento);
	var
		i,indiceMin:integer;
	begin
		min.nroPartida := VALOR_ALTO; indiceMin:= VALOR_ALTO;
		for i:= 1 to N do begin
			if (vReg[i].nroPartida < min.nroPartida) then begin
				indiceMin:=i;
				min:=vReg[i];
			end;
		end;
		if (indiceMin <> VALOR_ALTO) then 
			leer(v[indiceMin],vReg[indiceMin]);
	end;
var
	vReg:vRegistroNacimientos;
	regMaestro:registroMaestro;
	min:nacimiento;
	datoFallecido:fallecimiento;
	i:integer;
begin
	for i:= 1 to N do begin
		reset(vN[i]);
		leer(vN[i],vReg[i]);
	end;
	
	rewrite(maestro);
	minimo(vN,vReg,min);
	while (min.nroPartida <> VALOR_ALTO) do begin
	
		datoFallecido.nroPartida := VALOR_ALTO;	
		
		regMaestro.nroPartida := min.nroPartida;
		regMaestro.nombreYapellido := min.nombreYapellido;
		regMaestro.dir := min.dir;
		regMaestro.matriculaMedicoNacimiento := min.matriculaMedico;
		regMaestro.nombreYapellidoMADRE := min.nombreYapellidoMADRE;
		regMaestro.nombreYapellidoPADRE := min.nombreYapellidoPADRE;
		regMaestro.dniMadre := min.dniMadre;
		regMaestro.dniPadre := min.dniPadre;
		
		buscarFallecimiento(vF,datoFallecido,min.nroPartida);
		
		if (datoFallecido.nroPartida <> VALOR_ALTO) then begin
			regMaestro.fallecio:= true;
			regMaestro.fecha := datoFallecido.fecha;
			regMaestro.lugar := datoFallecido.lugar;	
			regMaestro.hora := datoFallecido.hora;
			regMaestro.matriculaMedicoFalleciminento := datoFallecido.matriculaMedico;
		end
		else regMaestro.fallecio:= false;
		
		write(maestro,regMaestro);
		
		minimo(vN,vReg,min);
		
	end;
	for i:= 1 to N do 
		close(vN[i]);
	close(maestro);
end;

procedure cargarFallecimientos (var v:vFallecimientos);
	procedure cargarFallecimiento (var arch:archFallecimiento);
	var
		f:fallecimiento;
	begin
		with f do begin
			write('NUMERO PARTIDA: ');readln(nroPartida);
			while (nroPartida <> 0) do begin
				//writeln('DNI: ');readln(dni);
				write('NOMBRE Y APELLIDO: ');readln(nombreYapellido);
				write('FECHA: ');readln(fecha);
				write('HORA: ');readln(hora);
				write('LUGAR: ');readln(lugar);
				write('MATRICULA MEDICO: ');readln(matriculaMedico);
				write(arch,f);
				writeln();
				write('NUMERO PARTIDA: ');readln(nroPartida);
			end;
		end;
	end;
var
	i:integer;
begin
	for i:= 1 to N do begin
		writeln('----FALLECIDOS ',i,' -----');
		rewrite(v[i]);
		cargarFallecimiento(v[i]);
		close(v[i]);
	end;
end;

procedure cargarNacimientos (var v:vNacimientos);
	procedure cargarNacimiento (var arch:archNacimiento);
	var
		n:nacimiento;
	begin
		with n do begin
			write('NUMERO PARTIDA: ');readln(nroPartida);
			while (nroPartida <> 0) do begin
				//writeln('DNI: ');readln(dni);
				write('NOMBRE Y APELLIDO: ');readln(nombreYapellido);
				write('NOMBRE Y APELLIDO PADRE: ');readln(nombreYapellidoPadre);
				write('NOMBRE Y APELLIDO MADRE: ');readln(nombreYapellidoMadre);
				write('DNI MADRE: ');readln(dniMadre);
				write('DNI PADRE: ');readln(dniPadre);
				write('MATRICULA MEDICO: ');readln(matriculaMedico);
				//cargarDireccion(dir);
				write(arch,n);
				writeln();
				write('NUMERO PARTIDA: ');readln(nroPartida);
			end;
		end;
	end;
var
	i:integer;
begin
	for i:= 1 to N do begin
		writeln('----NACIMIENTOS ',i,' -----');
		rewrite(v[i]);
		cargarNacimiento(v[i]);
		close(v[i]);
	end;
end;

procedure imprimirMaestro (var arch:archMaestro);
var
	r:registroMaestro;
begin
	reset(arch);
	with r do begin
		while (not EOF(arch)) do begin
			read(arch,r);
			writeln('Nro partida: ',nroPartida);
			writeln('Nombre y apellido: ',nombreYapellido);
			writeln('Nombre madre: ',nombreYapellidoMADRE);
			writeln('DNI madre: ',dniMadre);
			writeln('Nombre padre: ',nombreYapellidoPADRE);
			writeln('DNI padre:',dniPadre);
			writeln('Matricula medico nacimiento ',matriculaMedicoNacimiento);
			if (fallecio) then begin
				writeln('Matricula medico deceso ',matriculaMedicoFalleciminento);
				writeln('Fecha: ',fecha);
				writeln('Hora: ',hora);
				writeln('Lugar: ',lugar);
			end
			else	
				writeln('NO MURIO!');
			writeln();
		end;
	end;
	close(arch);
end;
//FALTA LISTA A TEXTO
var
	vN:vNacimientos;
	vF:vFallecimientos;
	maestro:archMaestro;
	st:str;
begin
	assign(vN[1],'detalleNacimiento1EJ18');
	assign(vN[2],'detalleNacimiento2EJ18');
	assign(vF[1],'detalleFallecimiento1EJ18');
	assign(vF[2],'detalleFallecimiento2EJ18');
	assign(maestro,'maestroEJ18');
	
	writeln('Queres cargar nacimientos?');readln(st);
	if (st = 'si') then 
		cargarNacimientos(vN);
	writeln('Queres cargar fallecimientos?');readln(st);
	if (st = 'si') then 
		cargarFallecimientos(vF);
	crearMaestro(vN,vF,maestro);
	imprimirMaestro(maestro);
end.
	

