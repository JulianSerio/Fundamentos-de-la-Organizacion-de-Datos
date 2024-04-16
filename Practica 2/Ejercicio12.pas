program untitled;
const 
	VALOR_ALTO = 9999;
type 
	str = string[20];
	log = record
		nroUsuario:integer;
		nombreUsuario:str;
		nombre:str;
		apellido:str;
		cantMailEnviados:integer;
	end;
	
	archivoGenerado = record
		nroUsuario:integer;
		cuentaDestino:str;
		cuerpoMensaje:string;
	end;
	
	archLog = file of log;
	archGenerado = file of archivoGenerado;

procedure actualizarMaestro (var maestro:archLog; var detalle:archGenerado);
	procedure leerDetalle (var arch:archGenerado; var dato:archivoGenerado);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.nroUsuario := VALOR_ALTO;
	end;
	procedure leerMaestro (var arch:archLog; var dato:log);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.nroUsuario := VALOR_ALTO;
	end;
var
	regMaestro:log;
	reg:archivoGenerado;
	nroActual,cantMails:integer;
begin
	reset(detalle);
	reset(maestro);
	leerDetalle(detalle,reg);
	while (reg.nroUsuario <> VALOR_ALTO) do begin
		leerMaestro(maestro,regMaestro);
		while (regMaestro.nroUsuario <> reg.nroUsuario) do 
			leerMaestro(maestro,regMaestro);
		nroActual:= regMaestro.nroUsuario;
		cantMails:=0;
		while (nroActual = reg.nroUsuario) do begin
			cantMails:= cantMails + 1;
			leerDetalle(detalle,reg);
		end;
		regMaestro.cantMailEnviados := regMaestro.cantMailEnviados + cantMails;
		//writeln(archTexto,nroActual,' ',regMaestro.cantMailEnviados);
		seek(maestro,filepos(maestro)-1);
		write(maestro,regMaestro);
	end;
	close(detalle);
	close(maestro);
end;

procedure generarArchivotxt (var maestro:archLog; var arch:Text);
var
	l:log;
begin
	rewrite(arch);
	reset(maestro);
	while (not EOF(maestro)) do begin
		read(maestro,l);
		writeln(arch,l.nroUsuario,' ',l.cantMailEnviados);
	end;
	close(arch);
	close(maestro);
end;

procedure menu (var maestro:archLog; var detalle:archGenerado; var arch:Text);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalle');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalle');
		writeln('5-Actualizar maestro');
		writeln('6-Generar archivo de texto');
		writeln('0-Finalizar');
		readln(op);
	end;
	
	procedure imprimirMaestro(var arch:archLog);
	var
		l:log;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,l);
			writeln('Nro Usuario: ',l.nroUsuario);
			writeln('Nombre usuario: ',l.nombreUsuario);
			writeln('Nombre: ',l.nombre);
			writeln('Apellido: ',l.apellido);
			writeln('Cantidad de mails enviados: ',l.cantMailEnviados);
			writeln();
		
		end;
		close(arch);
	end;
	procedure imprimirDetalle(var arch:archGenerado);
	var
		a:archivoGenerado;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			writeln('Nro Usuario: ',a.nroUsuario);
			writeln('Cuenta destino: ',a.cuentaDestino);
			writeln('Cuerpo mensaje: ',a.cuerpoMensaje);
		end;
	end;
	
	procedure cargarMaestro(var arch:archLog);
	var
		l:log;
	begin
		rewrite(arch);
		with l do begin
			write('NRO USUARIO: ');readln(nroUsuario);
			while (nroUsuario <> 0) do begin
				write('NOMBRE DE USUARIO: ');readln(nombreUsuario);
				write('NOMBRE : ');readln(nombre);	
				write('APELLIDO: ');readln(apellido);
				write('CANTIDAD DE MAIL ENVIADOS: ');readln(cantMailEnviados);
				write(arch,l);
				writeln();
				write('NRO USUARIO: ');readln(nroUsuario);
			end;
		end;
		close(arch);
	end;	
	procedure cargarDetalle(var arch:archGenerado);
	var
		a:archivoGenerado;
	begin
		rewrite(arch);
		with a do begin
			write('NRO USUARIO: ');readln(nroUsuario);
			while (nroUsuario <> 0) do begin
				write('CUENTA DESTINO: ');readln(cuentaDestino);
				write('CUERPO MENSAJE: ');readln(cuerpoMensaje);	
				write(arch,a);
				writeln();
				write('NRO USUARIO: ');readln(nroUsuario);
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
			2: cargarDetalle(detalle);
			3: imprimirMaestro(maestro);
			4: imprimirDetalle(detalle);
			5: actualizarMaestro(maestro,detalle);
			6: generarArchivotxt(maestro,arch);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;

var
	maestro:archLog;
	detalle:archGenerado;
	arch:Text;
BEGIN
	assign(maestro,'maestroEJ12');
	assign(detalle,'detalleEJ12');
	assign(arch,'archTexto.txt');
	menu(maestro,detalle,arch);
	
END.

