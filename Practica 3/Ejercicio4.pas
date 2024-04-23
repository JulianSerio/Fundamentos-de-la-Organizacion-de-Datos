program untitled;
type

	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;

procedure agregarFlor (var arch: tArchFlores ; nombre: string; codigo:integer);
var
	f:reg_flor;
begin
	f.nombre := nombre;
	f.codigo := codigo;
	write(arch,f);
end;

procedure eliminarFlor (var arch:tArchFlores; flor:reg_flor);
var
	f,head:reg_flor;
	encontre:boolean;
	posEncontre,posNeg:integer;
begin
	encontre:=false;
	reset(arch);
	while (not EOF(arch)) and (not encontre) do begin
		read(arch,f);
		if (f.codigo = flor.codigo) then begin
			encontre:=true;
			posEncontre := filepos(arch) - 1;
			posNeg := posEncontre * -1;
			f.codigo := posNeg;
			seek(arch,0);
			read(arch,head);
			seek(arch,0);
			write(arch,f);
			seek(arch,posEncontre); //me posiciono donde encontre 
			write(arch,head); //escribo el reg de la cabecera		
		end;
	end;
	close(arch);
end;

procedure listarATexto (var arch:tArchFlores; var texto:Text);
var
	f:reg_flor;
begin
	rewrite(texto);
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,f);
		if (f.codigo > 0) then begin
			writeln(texto,'Codigo: ',f.codigo,' Nombre: ',f.nombre);
			writeln(texto,' ');
		end;
	end;
	close(arch);
	close(texto);
end;

procedure imprimirFlores (var arch:tArchFlores);
var
	f:reg_flor;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,f);
		writeln('CODIGO: ',f.codigo);
		writeln('NOMBRE: ',f.nombre);
		writeln;
	end;
	close(arch);

end;

VAR
	a:tArchFlores;
	texto:Text;
	flor:reg_flor;
BEGIN
	assign(texto,'flores.txt');
	assign(a,'floresEJ4');
	rewrite(a);

	agregarFlor(a,'ZZZ',0);
	agregarFlor(a,'Margarita',5);
	agregarFlor(a,'Pimpollo',7);
	agregarFlor(a,'Opa',8);
	close(a);
	imprimirFlores(a);
	writeln('----------');
	
	flor.codigo:= 8;
	flor.nombre:= 'Opa';
	
	eliminarFlor(a,flor);
	imprimirFlores(a);
	listarATexto(a,texto);
END.

