% BASE DE DATOS DE RUTAS
% Formato: ruta(Origen, Destino, Medio, HoraSalida, HoraLlegada, CostoUSD, Disponible)
ruta(bogota, medellin, avion, 6, 7, 95, si).
ruta(bogota, medellin, bus, 7, 16, 35, si).
ruta(bogota, cali, avion, 7, 8, 90, si).
ruta(bogota, cartagena, avion, 8, 9, 120, si).
ruta(bogota, cartagena, bus, 5, 22, 70, no).
ruta(bogota, bucaramanga, bus, 6, 14, 30, si).
ruta(medellin, cartagena, avion, 10, 11, 120, no).
ruta(medellin, cartagena, bus, 8, 21, 55, si).
ruta(medellin, bogota, avion, 8, 9, 95, si).
ruta(medellin, cali, bus, 7, 16, 45, si).
ruta(cali, bogota, avion, 9, 10, 90, si).
ruta(cali, medellin, avion, 14, 15, 95, si).
ruta(cali, pasto, bus, 8, 16, 35, si).
ruta(cartagena, santa_marta, bus, 9, 13, 25, si).
ruta(cartagena, barranquilla, bus, 10, 12, 15, si).
ruta(cartagena, bogota, avion, 10, 11, 120, si).
ruta(barranquilla, santa_marta, bus, 8, 10, 12, si).
ruta(barranquilla, cartagena, bus, 9, 11, 15, si).
ruta(santa_marta, barranquilla, bus, 11, 13, 12, si).
ruta(pasto, cali, bus, 7, 15, 35, si).

% CONSULTAS BASICAS

% Muestra todas las rutas directas con su informacion completa
todas_rutas_directas(Origen, Destino) :-
    write('Rutas directas'), nl,
    ruta(Origen, Destino, Medio, Salida, _, Costo, Disp),
    write(Medio), write(' - '), write(Salida), write('h - $'), 
    write(Costo), write(' - '), write(Disp), nl,
    fail.
todas_rutas_directas(_, _).

% Filtra y muestra solo las rutas directas que estan disponibles
rutas_disponibles(Origen, Destino) :-
    write('Rutas disponibles'), nl,
    ruta(Origen, Destino, Medio, Salida, _, Costo, si),
    write(Medio), write(' - '), write(Salida), write('h - $'), write(Costo), nl,
    fail.
rutas_disponibles(_, _).

% Busca rutas directas que salgan dentro de un rango de horario especifico
rutas_por_horario(Origen, Destino, HMin, HMax) :-
    write('Rutas entre '), write(HMin), write('h y '), write(HMax), write('h'), nl,
    ruta(Origen, Destino, Medio, Salida, _, Costo, Disp),
    Salida >= HMin, Salida =< HMax,
    write(Medio), write(' - '), write(Salida), write('h - '), write(Disp), nl,
    fail.
rutas_por_horario(_, _, _, _).

% PLANIFICACION DE RUTAS CON ESCALAS

% Encuentra rutas entre ciudades, incluyendo rutas con escalas
% Retorna la ruta completa, tiempo total y costo total
encontrar_ruta(Origen, Destino, Ruta, Tiempo, Costo) :-
    encontrar_aux(Origen, Destino, [Origen], Ruta, Tiempo, Costo).

% Caso base: ruta directa entre origen y destino
encontrar_aux(Origen, Destino, Visitados, [Origen, Destino], Tiempo, Costo) :-
    ruta(Origen, Destino, _, Salida, Llegada, Costo, _),
    \+ member(Destino, Visitados),
    Tiempo is Llegada - Salida.

% Caso recursivo: busca rutas con escalas intermedias
encontrar_aux(Origen, Destino, Visitados, [Origen|Resto], TTotal, CTotal) :-
    ruta(Origen, Inter, _, S, L, C1, _),
    \+ member(Inter, Visitados),
    encontrar_aux(Inter, Destino, [Inter|Visitados], Resto, T2, C2),
    TTotal is (L - S) + T2,
    CTotal is C1 + C2.

% Muestra todas las rutas posibles con sus tiempos y costos
mostrar_rutas(Origen, Destino) :-
    write('Todas las rutas posibles'), nl,
    encontrar_ruta(Origen, Destino, Ruta, Tiempo, Costo),
    write(Ruta), write(' - '), write(Tiempo), write('h - $'), write(Costo), nl,
    fail.
mostrar_rutas(_, _).

% OPTIMIZACION

% Encuentra la ruta con menor tiempo de viaje
ruta_mas_rapida(Origen, Destino) :-
    findall([T, C, R], encontrar_ruta(Origen, Destino, R, T, C), Rutas),
    Rutas \= [],
    sort(1, @=<, Rutas, [[TMin, CMin, RMin]|_]),
    write('Ruta mas rapida: '), write(RMin), nl,
    write('Tiempo: '), write(TMin), write('h - Costo: $'), write(CMin), nl.

% Encuentra la ruta con menor costo
ruta_mas_barata(Origen, Destino) :-
    findall([C, T, R], encontrar_ruta(Origen, Destino, R, T, C), Rutas),
    Rutas \= [],
    sort(1, @=<, Rutas, [[CMin, TMin, RMin]|_]),
    write('Ruta mas barata: '), write(RMin), nl,
    write('Costo: $'), write(CMin), write(' - Tiempo: '), write(TMin), write('h'), nl.

% RUTAS DISPONIBLES CON ESCALAS

% Verifica que una ruta completa este disponible
% (todos sus tramos deben tener disponibilidad = si)
ruta_disponible(Origen, Destino, Ruta, Tiempo, Costo) :-
    encontrar_ruta(Origen, Destino, Ruta, Tiempo, Costo),
    verificar_disponibilidad(Ruta).

% Caso base: ruta de una sola ciudad siempre es valida
verificar_disponibilidad([_]).
% Caso recursivo: verifica que cada tramo este disponible
verificar_disponibilidad([C1, C2|Resto]) :-
    ruta(C1, C2, _, _, _, _, si),
    verificar_disponibilidad([C2|Resto]).

% Muestra las 3 mejores alternativas disponibles segun criterio (tiempo o costo)
mejor_alternativa(Origen, Destino, Criterio) :-
    write('Mejores alternativas disponibles ('), write(Criterio), write(')'), nl,
    (Criterio = tiempo ->
        findall([V, R, T, C], (ruta_disponible(Origen, Destino, R, T, C), V = T), Rs)
    ;
        findall([V, R, T, C], (ruta_disponible(Origen, Destino, R, T, C), V = C), Rs)
    ),
    Rs \= [],
    sort(1, @=<, Rs, Ordenadas),
    mostrar_top3(Ordenadas, 1).

% Muestra las primeras 3 opciones de una lista ordenada
mostrar_top3([], _).
mostrar_top3(_, 4) :- !.
mostrar_top3([[_, R, T, C]|Resto], N) :-
    write(N), write('. '), write(R), 
    write(' - '), write(T), write('h - $'), write(C), nl,
    N1 is N + 1,
    mostrar_top3(Resto, N1).

% CONSULTAS ADICIONALES

% Cuenta cuantas rutas salen desde una ciudad especifica
contar_rutas(Ciudad) :-
    findall(1, ruta(Ciudad, _, _, _, _, _, _), L),
    length(L, Total),
    write('Rutas desde '), write(Ciudad), write(': '), write(Total), nl.

% Lista todas las rutas que usan un medio de transporte especifico
rutas_por_medio(Medio) :-
    write('Rutas en '), write(Medio), nl,
    ruta(O, D, Medio, _, _, Costo, _),
    write(O), write(' -> '), write(D), write(' - $'), write(Costo), nl,
    fail.
rutas_por_medio(_).

% Busca rutas con escalas que salgan en un rango de horario especifico
rutas_escalas_horario(Origen, Destino, HMin, HMax) :-
    write('Rutas con escalas saliendo entre '), 
    write(HMin), write('h y '), write(HMax), write('h'), nl,
    encontrar_ruta(Origen, Destino, Ruta, Tiempo, Costo),
    Ruta = [Origen, PrimerDestino|_],
    ruta(Origen, PrimerDestino, _, Salida, _, _, _),
    Salida >= HMin, Salida =< HMax,
    write(Ruta), write(' - '), 
    write(Tiempo), write('h - $'), write(Costo), nl,
    fail.
rutas_escalas_horario(_, _, _, _).

% Sugiere automaticamente la mejor alternativa disponible
% Prioriza rutas directas, si no hay muestra alternativas con escalas
sugerir_mejor_alternativa(Origen, Destino) :-
    (ruta(Origen, Destino, _, _, _, _, si) ->
        write('HAY RUTA DIRECTA DISPONIBLE:'), nl,
        rutas_disponibles(Origen, Destino)
    ;
        write('NO HAY RUTA DIRECTA DISPONIBLE'), nl,
        write('Mostrando mejores alternativas con escalas:'), nl, nl,
        mejor_alternativa(Origen, Destino, costo)
    ).

% MENU PRINCIPAL

menu :-
    nl,
    write('SISTEMA DE PLANIFICACION DE VIAJES'), nl,
    nl,
    write('CIUDADES DISPONIBLES:'), nl,
    write('  bogota, medellin, cali, cartagena'), nl,
    write('  bucaramanga, pasto, santa_marta, barranquilla'), nl,
    nl,
    write('CONSULTAS DISPONIBLES:'), nl,
    write('1. todas_rutas_directas(Origen, Destino)'), nl,
    write('   Muestra todas las rutas directas entre dos ciudades'), nl,
    nl,
    write('2. rutas_disponibles(Origen, Destino)'), nl,
    write('   Muestra solo las rutas directas disponibles'), nl,
    nl,
    write('3. rutas_por_horario(Origen, Destino, HMin, HMax)'), nl,
    write('   Filtra rutas directas por rango de horario de salida'), nl,
    nl,
    write('4. mostrar_rutas(Origen, Destino)'), nl,
    write('   Muestra todas las rutas posibles incluyendo escalas'), nl,
    nl,
    write('5. ruta_mas_rapida(Origen, Destino)'), nl,
    write('   Encuentra la ruta con menor tiempo de viaje'), nl,
    nl,
    write('6. ruta_mas_barata(Origen, Destino)'), nl,
    write('   Encuentra la ruta con menor costo'), nl,
    nl,
    write('7. mejor_alternativa(Origen, Destino, tiempo/costo)'), nl,
    write('   Muestra top 3 mejores rutas disponibles por criterio'), nl,
    nl,
    write('8. sugerir_mejor_alternativa(Origen, Destino)'), nl,
    write('   Sugiere la mejor opcion disponible automaticamente'), nl,
    nl,
    write('9. rutas_escalas_horario(Origen, Destino, HMin, HMax)'), nl,
    write('   Busca rutas con escalas filtrando por horario inicial'), nl,
    nl,
    write('10. contar_rutas(Ciudad)'), nl,
    write('    Cuenta cuantas rutas salen desde una ciudad'), nl,
    nl,
    write('11. rutas_por_medio(avion/bus)'), nl,
    write('    Lista todas las rutas de un medio de transporte'), nl,
    nl,
    write('Escriba "menu." para ver este menu nuevamente'), nl,
    nl.