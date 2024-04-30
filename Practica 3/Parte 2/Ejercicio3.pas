program untitled;
const
	N = 5;
	VALOR_ALTO = 9999;
type
	rango = 1..N;
	
	log = record
		codUsuario:integer;
		fecha:integer;
		tiempo:integer;
	end;
	
	registroMaestro = record
		codUsuario:integer;
		fecha:integer; //es como si tuvieramos en el ej anterior mesa
		tiempoTotal:integer;
	end;
	
	archDetalle = file of log;
	archMaestro = file of registroMaestro;
	vDetalles = array [rango] of archDetalle;

	

procedure leerDetalle (var arch:archDetalle; var dato:log);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.codUsuario := VALOR_ALTO;
end;

procedure leerMaestro (var arch:archMaestro; var dato:registroMaestro);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.codUsuario := VALOR_ALTO;
end;	

procedure crearMaestro (var v:vDetalles; var maestro:archMaestro);
var
	regMae:registroMaestro;
	regDet:log;
	i:integer;
begin
	for i:= 1 to N do begin
		reset(v[i]);
	end;
	
	leerDetalle(v[1],regDet);
	rewrite(maestro);
	regMae.codUsuario := regDet.codUsuario;
	regMae.fecha := regDet.fecha;
	regMae.tiempoTotal := regDet.tiempo;
	write(maestro,regMae);
	close(maestro);
	
	for i:= 1 to N do begin
		leerDetalle(v[i],regDet);
		while (regDet.codUsuario <> VALOR_ALTO) do begin
			reset(maestro);
			leerMaestro(maestro,regMae);
			while (regMae.codUsuario <> VALOR_ALTO) and (regMae.codUsuario <> regDet.codUsuario) do 
				leerMaestro(maestro,regMae);
			if (regMae.codUsuario = regDet.codUsuario) then begin
				regMae.tiempoTotal := regMae.tiempoTotal + regDet.tiempo;
				seek(maestro,filepos(maestro) - 1);
				write(maestro,regMae);
			end
			else begin
				regMae.codUsuario := regDet.codUsuario;
				regMae.fecha := regDet.fecha;
				regMae.tiempoTotal := regDet.tiempo;
				write(maestro,regMae);
			end;
			close(maestro);
			leerDetalle(v[i],regDet);
		end;
	end;
	for i:= 1 to N do begin
		close(v[i]);
	end;
end;
	
procedure menu (var vDet:vDetalles; var maestro:archMaestro);
	procedure cargarDetalle (var arch:archDetalle);
	var
		l:log;
	begin
		with l do begin
			write('CODIGO DE USUARIO: ');readln(codUsuario);
			while (codUsuario <> 0) do begin
				write('FECHA: ');readln(fecha);
				write('TIEMPO: ');readln(tiempo);
				writeln();
				write(arch,l);
				write('CODIGO DE USUARIO: ');readln(codUsuario);
			end;
		end;
	end;
	procedure cargarDetalles (var v:vDetalles);
	var
		i:integer;
	begin
		for i:= 1 to N do begin
			writeln('-----DETALLE ',i,' -----');
			rewrite(v[i]);
			cargarDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure imprimirDetalle (var arch:archDetalle);
	var
		l:log;
	begin
		while (not EOF(arch)) do begin
			read(arch,l);
			writeln('CODIGO USUARIO: ',l.codUsuario);
			writeln('FECHA: ',l.fecha);
			writeln('TIEMPO: ',l.tiempo);
			writeln();
		end;
	end;
	
	procedure imprimirDetalles (var v:vDetalles);
	var
		i:integer;
	begin
		for i:= 1 to N do begin
			writeln('-----DETALLE ',i,' -----');
			reset(v[i]);
			imprimirDetalle(v[i]);
			close(v[i]);
		end;
	end;

	procedure imprimirMaestro(var arch:archMaestro);
	var
		i:registroMaestro;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,i);
			writeln('-------------');
			writeln('CODIGO USUARIO: ',i.codUsuario);
			writeln('FECHA: ',i.fecha);
			writeln('TIEMPO TOTAL: ',i.tiempoTotal);
		end;
		close(arch);
	end;
		
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar detalles');
		writeln('2-Imprimir detalles');
		writeln('3-Crear maestro con detalles');
		writeln('4-Imprimir maestro');
		writeln('0-Finalizar');
		readln(op);
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarDetalles(vDet);
			2: imprimirDetalles(vDet);
			3: crearMaestro(vDet,maestro);
			4: imprimirMaestro(maestro);
		end;
		mostrarOpciones(op);
	end;
end;
	
var
	vDet:vDetalles;
	maestro:archMaestro;
BEGIN
	assign(maestro,'maestroEJ3');
	assign(vDet[1],'detalle1');
	assign(vDet[2],'detalle2');
	assign(vDet[3],'detalle3');
	assign(vDet[4],'detalle4');
	assign(vDet[5],'detalle5');
	menu(vDet,maestro);
	
END.

