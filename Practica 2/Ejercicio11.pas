program untitled;
const
	VALOR_ALTO = 9999;
type	
	rangoMes = 1..12;
	rangoDias = 1..31;
	archivo = record
		anio:integer;
		mes:rangoMes;
		dia:rangoDias;
		idUsuario:integer;
		tiempoDeAcceso:integer;
	end;
	
	archMaestro = file of archivo;
	
procedure procesarMaestro (var maestro:archMaestro);
	procedure leer (var arch:archMaestro; var dato:archivo);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.anio := VALOR_ALTO;
	end;
var
	a:archivo;
	anioActual,mesActual,diaActual,idActual:integer;
	anioABuscar:integer;
	tiempoAnio,tiempoMes,tiempoDia,tiempoUsuario:integer;
begin
	reset(maestro);
	leer(maestro,a);
	write('INGRESE ANIO A BUSCAR: ');readln(anioABuscar);
	while(a.anio <> anioABuscar) and (a.anio <> VALOR_ALTO)do begin
           leer(maestro,a);
    end;
	if (a.anio = VALOR_ALTO) then begin
		writeln('Anio no encontrado!');
	end
	else begin
		anioActual := a.anio;
		tiempoAnio := 0;
		writeln('Anio:- ',anioActual);
	end;
	while (a.anio <> VALOR_ALTO) and (a.anio = anioActual) do begin
		mesActual := a.mes;
		tiempoMes:=0;
		writeln(' Mes:- ',mesActual);
		while (a.anio = anioActual) and (a.mes = mesActual) do begin
			diaActual := a.dia;
			tiempoDia:=0;
			writeln('  Dia:- ',diaActual);
			while (a.anio = anioActual) and (a.mes = mesActual) and (a.dia = diaActual) do begin
				idActual:= a.idUsuario;
				tiempoUsuario:=0;
				writeln('   Id:- ',idActual,' ');
				while (a.anio = anioActual) and (a.mes = mesActual) and (a.dia = diaActual) and (idActual = a.idUsuario) do begin
					tiempoUsuario := tiempoUsuario + a.tiempoDeAcceso;
					leer(maestro,a);
				end;
				write('   Tiempo total de acceso en el dia ',diaActual,' mes ',mesActual,' es: ',tiempoUsuario);
				tiempoDia:= tiempoDia + tiempoUsuario;
				writeln();
			end; 
			writeln('  Tiempo total de acceso dia ',diaActual,' mes ',mesActual,' es: ',tiempoDia);
			tiempoMes:= tiempoMes + tiempoDia;
			writeln();
		end;
		writeln('Total tiempo de acceso mes ',mesActual,' es: ',tiempoMes);
		tiempoAnio := tiempoAnio + tiempoMes;
		writeln();
	end;
	writeln('Total tiempo de acceso anio ',anioActual,' es: ',tiempoAnio);
	close(maestro);
end;
	
procedure menu (var maestro:archMaestro);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Imprimir maestro');
		writeln('3-Procesar archivo');
		writeln('0-Finalizar');
		readln(op);
	end;
	
	procedure imprimirMaestro (var arch:archMaestro);
	var
		a:archivo;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			writeln('Anio: ',a.anio);
			writeln('Mes: ',a.mes);
			writeln('Dia: ',a.dia);
			writeln('Id Usuario: ',a.idUsuario);
			writeln('Tiempo de acceso: ',a.tiempoDeAcceso);
			writeln();
		end;
		close(arch);
	end;
	
	procedure cargarMaestro(var arch:archMaestro);
	var
		a:archivo;
	begin
		rewrite(arch);
		with a do begin
			write('ANIO: ');readln(anio);
			while (anio <> 0) do begin
				write('MES: ');readln(mes);
				write('DIA: ');readln(dia);	
				write('ID USUARIO: ');readln(idUsuario);
				write('TIEMPO DE ACCESO: ');readln(tiempoDeAcceso);
				write(arch,a);
				writeln();
				write('ANIO: ');readln(anio);
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
			2: imprimirMaestro(maestro);
			3: procesarMaestro(maestro);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;

var
	maestro:archMaestro;
BEGIN
	assign(maestro,'maestroEJ11');
	menu(maestro);
END.

