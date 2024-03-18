program prueba;
type 
	archivo = file of Integer;

procedure menoresYpromedio (var arch:archivo);
var
	prom:real;
	menores,cantidad,num:integer;
begin
	reset(arch);
	menores:=0; cantidad:=0; prom:=0;
	while (not EOF(arch)) do begin
		read(arch,num);
		writeln(num);
		
		cantidad:= cantidad + 1;
		prom := prom + num;
		if (num < 1500) then menores:= menores + 1;
			
	end;
	close(arch);
	prom := prom / cantidad;
	writeln('Numeros menores a 1500: ', menores);
	writeln('Promedio: ',prom);
end;

procedure cargarFile (var arch:archivo);
var
	num:integer;
begin
	write('Ingrese numero: ');
	readln(num);
	while (num <> 30000) do begin
		write(arch,num);
	
		write('Ingrese numero: ');
		readln(num);
	end;
	close(arch);
end;

var
	arch:archivo;
	path:string;
BEGIN
	{C:\Users\Julian\Desktop\FOD\datos.dat;}
	writeln('Ingrese el nombre del archivo');
	readln(path);
	
	assign(arch,path);
	rewrite(arch);
	
	cargarFile(arch);
	menoresYpromedio(arch);
END.
