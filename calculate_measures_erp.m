%% Procesar ERP

%% Peak to peak
% VER QUE PEAKS CONSIDERAR, ¿CUALES SERIAN LOS ERP? --> COMO SUAVIZAR LA
% CURVA

% VER SI HAY VARIOS ERP EN UN CALCULO -> DEFINIR VENTANAS (?) PARA CALCULAR
% CADA MEDIDA ??

% max(data_time.avg) %% si > 0
% min(data_time.avg) %% si < 0

% max - min 

%% amplitud

% max(data_time.avg) %% si > 0
% min(data_time.avg) %% si < 0

% max
% -min

% findpeaks(data_time.avg) %% calcula los peaks positivos

%% Area bajo la curva

% area(data_time.time(...), data_time.avg(CHAN,...)) %% la dibuja
% trapz(data_time.time(...), data_time.avg(CHAN,...)) %% calcula el area

%% Latencia

% max(data_time.avg) %% si > 0
% min(data_time.avg) %% si < 0

% find(max)
% find(min)
