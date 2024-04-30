program untitled;
const
	VALOR_ALTO = 9999;
type

	info = record
		codLocalidad:integer;
		mesa:integer;
		cantVotos:integer;
	end;
	
	total = record
		codLocalidad:integer;
		totalVotos:integer;
	end;
	
	archivo = file of info;
	archivoTotal = file of total;

procedure leerMaestro (var arch:archivo; var dato:info);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.codLocalidad := VALOR_ALTO;
end;

procedure leerAux (var arch:archivoTotal; var dato:total);
begin
	if (not EOF(arch)) then read(arch,dato)
	else dato.codLocalidad := VALOR_ALTO;
end;
procedure actualizarMaestro (var maestro:archivo; var archAux:archivoTotal);
var
	regMae:info;
	regAux:total;
begin
	reset(maestro);
	rewrite(archAux);
	leerMaestro(maestro,regMae);
	regAux.codLocalidad := regMae.codLocalidad;
	regAux.totalVotos := regMae.cantVotos;
	write(archAux,regAux);
	close(archAux);
	
	leerMaestro(maestro,regMae);
	while (regMae.codLocalidad <> VALOR_ALTO) do begin
		reset(archAux);
		leerAux(archAux,regAux);
		while (regAux.codLocalidad <> VALOR_ALTO) and (regAux.codLocalidad <> regMae.codLocalidad) do
			leerAux(archAux,regAux);
		if (regAux.codLocalidad = regMae.codLocalidad) then begin
			regAux.totalVotos := regAux.totalVotos + regMae.cantVotos;
			seek(archAux,filepos(archAux) - 1);
			write(archAux,regAux);
		end
		else begin
			regAux.codLocalidad := regMae.codLocalidad;
			regAux.totalVotos := regMae.cantVotos;
			write(archAux,regAux);
		end;
		close(archAux);
		leerMaestro(maestro,regMae);
	end;
	close(maestro);
end;

procedure imprimirArchivo (var arch:archivoTotal);
var
	totalGeneral:integer;
	reg:total;
begin
	totalGeneral:=0;
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,reg);
		writeln('Codigo de localidad: ',reg.codLocalidad,' Total Votos: ',reg.totalVotos);
		totalGeneral:= reg.totalVotos + totalGeneral;
		writeln();
	end;
	close(arch);
	writeln('Total general de votos: ',totalGeneral);
end;
	
procedure menu (var maestro:archivo);
	procedure cargarMaestro (var arch:archivo);
	var
		i:info;
	begin
		rewrite(arch);
		with i do begin
			write ('CODIGO LOCALIDAD: '); readln (codLocalidad);
			while (codLocalidad <> 0) do begin
				write ('MESA: '); readln (mesa);
				write ('CANTIDAD VOTOS: '); readln(cantVotos);
				write(arch,i);
				writeln();
				write ('CODIGO LOCALIDAD: '); readln (codLocalidad);
			end;	
		end;
		close(arch);
	end;

	procedure imprimirMaestro(var arch:archivo);
	var
		i:info;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,i);
			writeln('-------------');
			writeln('CODIGO: ',i.codLocalidad);
			writeln('MESA: ',i.mesa);
			writeln('CANTIDAD VOTOS: ',i.cantVotos);

		end;
		close(arch);
	end;
		
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Imprimir maestro');
		writeln('3-Actualizar maestro');
		writeln('4-Imprimir archivo aux');
		writeln('0-Finalizar');
		readln(op);
	end;
var
	op:integer;
	archAux:archivoTotal;
begin
	assign(archAux,'archivoAUXEJ2');
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1: cargarMaestro(maestro);
			2: imprimirMaestro(maestro);
			3: actualizarMaestro(maestro,archAux);
			4: imprimirArchivo(archAux);
		end;
		mostrarOpciones(op);
	end;
end;

var
	maestro:archivo;
BEGIN
	assign(maestro,'maestroEJ2');
	menu(maestro);
END.

