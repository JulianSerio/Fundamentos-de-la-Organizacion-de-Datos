program untitled;
const 
	VALOR_ALTO = 9999;
type
	str = string[20];
	info = record
		codLocalidad:integer;
		codMunicipio:integer;
		codHospital:integer;
		fecha:integer;
		positivos:integer;
		nombreLocalidad:str;
		nombreMunicipio:str;
		nombreHospital:str;
	end;
	
	archMaestro = file of info;

procedure cargarMaestro(var arch:archMaestro);
var
	i:info;
begin
	rewrite(arch);
	with i do begin
		write('CODIGO DE LOCALIDAD: ');readln(codLocalidad);
		while (codLocalidad <> 0) do begin
			write('CODIGO DE MUNICIPIO: ');readln(codMunicipio);
			write('CODIGO DE HOSPITAL: ');readln(codHospital);
			write('POSITIVOS: ');readln(positivos);
			write('FECHA: ');readln(fecha);
			writeln();
			write(arch,i);
			write('CODIGO DE LOCALIDAD: ');readln(codLocalidad);
		end;
	end;
	close(arch);
end;
	
procedure imprimirMaestro(var arch:archMaestro);
var
	i:info;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,i);
		writeln('Cod Localidad: ',i.codLocalidad);
		writeln('Cod Municipio: ',i.codMunicipio);
		writeln('Cod Hospital: ',i.codHospital);
		writeln('Positivos: ',i.positivos);
		writeln('Fecha: ',i.fecha);
		writeln();
	end;
	close(arch);
end;

procedure procesarMaestro (var maestro:archMaestro);
	procedure leer (var arch:archMaestro; var dato:info);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.codLocalidad := VALOR_ALTO;
	end;
var
	reg:info;
	locActual,muniActual,hosActual:integer;
	casosHospital,casosMunicipio,casosLocalidad,casosProvincia:integer;
begin
	reset(maestro);
	leer(maestro,reg);
	casosProvincia:=0;
	while (reg.codLocalidad <> VALOR_ALTO) do begin
		casosLocalidad:=0;
		locActual := reg.codLocalidad;
		writeln('Localidad: ',locActual);
		while (locActual = reg.codLocalidad) do begin
			casosMunicipio:=0;
			muniActual := reg.codMunicipio;
			writeln('  Municipio: ',reg.codMunicipio);
			while (locActual = reg.codLocalidad) and (muniActual = reg.codMunicipio) do begin
				casosHospital:=0;
				hosActual := reg.codHospital;
				writeln('    Hospital: ',hosActual);
				while (locActual = reg.codLocalidad) and (muniActual = reg.codMunicipio) and (hosActual = reg.codHospital) do begin
					casosHospital := casosHospital + reg.positivos;
					leer(maestro,reg);
				end;
				writeln('    Cantidad casos Hospital: ',hosActual,' ',casosHospital);
				casosMunicipio := casosMunicipio + casosHospital;
			end;		
			writeln('  Cantidad casos Municipio: ',muniActual,' ',casosMunicipio);
			casosLocalidad:= casosLocalidad + casosMunicipio;
			writeln;
		end;
		writeln('Cantidad casos Localidad: ',locActual,' ',casosLocalidad);
		casosProvincia:= casosProvincia + casosLocalidad;
		writeln;
	end;
	writeln;
	writeln('Cantidad casos TOTALES en la provincia: ',casosProvincia);
	close(maestro);
end;
var

//FALTA LISTAR A TEXTO
	maestro:archMaestro;
	st:str;
BEGIN
	assign(maestro,'maestroEJ17');
	write('Queres cargar el maestro? ');readln(st);
	if (st = 'si') then
		cargarMaestro(maestro);
	procesarMaestro(maestro);
END.

