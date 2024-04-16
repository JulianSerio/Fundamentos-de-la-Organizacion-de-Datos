program untitled;
const 
	VALOR_ALTO = 999;
type
	
	informacionMaestro = record
		codProvincia:integer;
		codLocalidad:integer;
		numMesa:integer;
		votos:integer;
	end;
	
	informacionArchivo = record
		codProvincia:integer;
		codLocalidad:integer;
		votosLocalidad:integer;
		votosProvincia:integer;
		votosGeneral:integer;
	end;
	
	archMaestro = file of informacionMaestro;
	archivo = file of informacionArchivo;
	
procedure cargarArchivo (var maestro:archMaestro);
	procedure leer (var arch:archMaestro; var dato:informacionMaestro);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.codProvincia := VALOR_ALTO;
	end;
var
	mesa:informacionMaestro;
	provinciaActual,localidadActual,votosLocalidad,votosProvincia,votosGeneral:integer;
begin
	reset(maestro);
	leer(maestro,mesa);
	votosGeneral:= 0;
	while (mesa.codProvincia <> VALOR_ALTO) do begin
		provinciaActual:= mesa.codProvincia;
		writeln('CODIGO DE PROVINCIA: ',provinciaActual);
		votosProvincia:=0;
		while (provinciaActual= mesa.codProvincia) do begin
			localidadActual := mesa.codLocalidad;
			writeln('---Codigo de localidad: ',localidadActual);
			votosLocalidad:=0;
			while (provinciaActual= mesa.codProvincia) and (localidadActual = mesa.codLocalidad) do begin
				votosLocalidad := votosLocalidad + mesa.votos;
				leer(maestro,mesa)
			end;
			writeln('---Total votos: ',votosLocalidad);
			votosProvincia:= votosProvincia + votosLocalidad;
			writeln();
		end;
		writeln('Total votos Provincia: ',votosProvincia);
		votosGeneral:= votosGeneral + votosProvincia;
		writeln();
	end;
	writeln('Total General de votos: ',votosGeneral);
	writeln();
	close(maestro);
end;
	

procedure menu (var maestro:archMaestro);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar detalles');
		writeln('2-Imprimir detalles');
		writeln('3-Cargar archivo');
		writeln('4-Imprmir archivo');
		writeln('0-Finalizar');
		readln(op);
	end;
	
	procedure imprimirDatos (var arch:archMaestro);
	var
		info:informacionMaestro;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,info);
			writeln('Codigo provincia: ',info.codProvincia);
			writeln('Codigo localidad: ',info.codLocalidad);
			writeln('Numero de mesa: ',info.numMesa);
			writeln('Votos: ',info.votos);
			writeln();
		end;
		close(arch);
	end;
	
	procedure cargarMaestro(var arch:archMaestro);
	var
		info:informacionMaestro;
	begin
		rewrite(arch);
		with info do begin
			write('CODIGO DE PROVINCIA: ');readln(codProvincia);
			while (codProvincia <> 0) do begin
				write('CODIGO DE LOCALIDAD: ');readln(codLocalidad);
				write('NUMERO DE MESA: ');readln(numMesa);	
				write('VOTOS: ');readln(votos);
				write(arch,info);
				writeln();
				write('CODIGO DE PROVINCIA: ');readln(codProvincia);
			end;
		end;
		close(arch);
	end;
	
	
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of
			1: cargarMaestro(maestro);
			2: imprimirDatos(maestro);
			3: cargarArchivo(maestro);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;

var
	maestro:archMaestro;
BEGIN
	assign(maestro,'maestroEJ9');
	menu(maestro);
	
END.

