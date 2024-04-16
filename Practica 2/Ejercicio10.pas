program untitled;
const
	N = 15;
	VALOR_ALTO = 999;
type
	rango = 1..N;
	empleado = record
		departamento:integer;
		division:integer;
		num:integer;
		categoria:rango;
		cantHoras:integer;
	end;
	
	archMaestro = file of empleado;
	
	vCategorias = array [rango] of real;
	
procedure cargarCategorias (var v:vCategorias; var txt:Text);
var
	cat:rango;
	valor:real;
begin
	reset(txt);
	while (not EOF(txt)) do begin
		readln(txt,cat,valor);
		v[cat] := valor;
	end;
	close(txt);
end;

procedure procesarMaestro (var maestro:archMaestro; v:vCategorias);
	procedure leer(var arch:archMaestro; var dato:empleado);
	begin
		if (NOT EOF(arch)) then read(arch,dato)
		else dato.departamento := VALOR_ALTO;
	end;
var
	e:empleado;
	depActual,divActual,numActual,horasDivision,horasDepartamento,horasEmpleado:integer;
	importe,totalDivision,totalDepartamento:real;
begin
	reset(maestro);
	leer(maestro,e);
	while (e.departamento <> VALOR_ALTO) do begin
		depActual:= e.departamento;
		totalDepartamento:=0;
		horasDepartamento:=0;
		writeln('DEPARTAMENTO ',depActual);
		while (depActual = e.departamento) do begin
			divActual := e.division;
			horasDivision:=0;
			totalDivision:=0;
			writeln('---Division ',divActual);
			while (depActual = e.departamento) and (divActual = e.division) do begin
				numActual := e.num;
				importe:=0;
				horasEmpleado:=0;
				writeln('------Numero de Empleado ',numActual);
				while (depActual = e.departamento) and (divActual = e.division) and (numActual = e.num) do begin
					importe := importe + (v[e.categoria] * e.cantHoras);
					horasEmpleado := horasEmpleado + e.cantHoras;
					leer(maestro,e);
				end;
				writeln('------Total de Hs. ',horasEmpleado,' Importe a cobrar ',importe:2:0);
				horasDivision:= horasDivision + horasEmpleado;
				totalDivision:= totalDivision + importe;
				writeln();
			end;
			writeln('---Total horas division:',horasDivision);
			writeln('---Monto total por division: ',totalDivision:2:0);
			totalDepartamento := totalDepartamento + totalDivision;
			horasDepartamento := horasDepartamento + horasDivision;
			writeln();
		end;
		writeln('Total horas departamento:',horasDepartamento);
		writeln('Monto total departamento: ',totalDepartamento:2:0);
		writeln();
	end;
	close(maestro);
	
end;
	
procedure menu (var maestro:archMaestro; var v:vCategorias; var txt:Text);
	procedure mostrarOpciones(var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Imprimir maestro');
		writeln('3-Procesar archivo');
		writeln('4-Cargar categorias');
		writeln('0-Finalizar');
		readln(op);
	end;
	
	procedure imprimirMaestro (var arch:archMaestro);
	var
		e:empleado;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,e);
			writeln('Departamento: ',e.departamento);
			writeln('Division: ',e.division);
			writeln('Numero: ',e.num);
			writeln('Categoria: ',e.categoria);
			writeln('Cantidad de horas: ',e.cantHoras);
			writeln();
		end;
		close(arch);
	end;
	
	procedure cargarMaestro(var arch:archMaestro);
	var
		e:empleado;
	begin
		rewrite(arch);
		with e do begin
			write('DEPARTAMENTO: ');readln(departamento);
			while (departamento <> 0) do begin
				write('DIVISION: ');readln(division);
				write('NUMERO: ');readln(num);	
				write('CATEGORIA: ');readln(categoria);
				write('CANTIDAD DE HORAS: ');readln(cantHoras);
				write(arch,e);
				writeln();
				write('DEPARTAMENTO: ');readln(departamento);
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
			3: procesarMaestro(maestro,v);
			4: cargarCategorias(v,txt);
			else writeln('Opcion incorrecta');
		end;
		mostrarOpciones(op);
	end;	
end;
var
	v:vCategorias;
	txt:Text;
	maestro:archMaestro;
BEGIN
	assign(maestro,'maestroEJ10');
	assign(txt,'Valores_Hora.txt');
	menu(maestro,v,txt);
END.

