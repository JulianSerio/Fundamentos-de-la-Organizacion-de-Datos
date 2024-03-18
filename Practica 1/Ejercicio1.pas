program prueba;
type 
	archivo = file of Integer;

var
	arch:archivo;
	num:integer;
	path:string;
BEGIN
	{C:\Users\Julian\Desktop\FOD\datos.dat;}
	writeln('Ingrese el nombre del archivo');
	readln(path);
	
	assign(arch,path);
	rewrite(arch);
	
	write('Ingrese numero: ');
	readln(num);
	while (num <> 30000) do begin
		write(arch,num);
	
		write('Ingrese numero: ');
		readln(num);
	end;
	close(arch);
	
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,num);
		writeln(num);
	
	end;
	close(arch);
END.

