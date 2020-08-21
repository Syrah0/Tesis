%%%%%%%%%%%%% calcular ERP

%% Cargar data
path = 'E:\DatosPsiquiatrico\Procesados\DBF\';
file = 'CNTF_009_DBF_R1__FINISH.mat';
data = load([path,file]);
data = data.DATA_REJECT;

%% Elegir trial y hacer filtro pasa bajo a 40
ID             = 12; % event
cfg            = [];
cfg.trial      = find(data.trialinfo(:,1)==ID); % por cada eventtype
cfg.lpfilter   = 'yes';
cfg.lpfreq     = 40;
cfg.keeptrials = 'no';

data = ft_preprocessing(cfg, data);
erps = ft_timelockanalysis(cfg, data); %% calcula ERP

%%%% The most important field is data_time.avg, containing the average over all trials for each sensor.

%% correccion de linea base --> el promedio lo corrigen
cfg          = [];
cfg.baseline = [-0.2 -0.1]; % no usar linea base en el cero
timelock     = ft_timelockbaseline(cfg, erps);
%%%timelock_CROM_PAT = timelock; %Cambia categoria y sujetos que se
%%%analiza?
avg = timelock.avg;
times = timelock.time;

save([path, file(1:8), '_ERP_', sprintf('%i', ID), '.mat'],'timelock')
save([path, file(1:8), '_ERP_', sprintf('%i', ID), '_AVG.mat'],'avg') % MAS IMPORTANTE PARA TRABAJAR
save([path, file(1:8), '_ERP_', sprintf('%i', ID), '_TIME.mat'],'times')

%%%% seleccionar electrodos de interes y promediar ERP (promedio para el sujeto)

%% sacar el ERP por grupo sacando el GRAN PROMEDIO

%%%% sacar PROMEDIO de los ERP de cada ELECTRODO => ERP POR PERSONA

%% Graficar ERPs
cfg          = [];
cfg.fontsize = 6;
cfg.layout   = 'biosemi64.mat';
cfg.channel  = 'O2';
cfg.xlim     = [-0.250 1];

figure;
ft_singleplotER(cfg,timelock); %% PARA PLOTEAR DE 1 CANAL



%% Graficar ERPs
cfg          = [];
cfg.fontsize = 6;
cfg.layout   = 'biosemi64.mat';
cfg.channel  = 'O2';
cfg.xlim     = [-0.250 1];

figure;
ft_singleplotER(cfg,timelock); %% PARA PLOTEAR DE 1 CANAL

%% Calcular el gran promedio 

%%% ANALIZAR ESTO
%%% GRAND_AVERAGE_ERP_SinSal_CONT{n,1} = eval(sprintf(['timelock_ERP_' CAT{1,1} '_' SUJ{1,1}])); %CAMBIAR NOMBRE VARIABLE

% cfg                = [];
% cfg.channel        = 'all';
% cfg.latency        = 'all'; %in seconds or 'all' (default = 'all')
% cfg.keepindividual = 'no';
% cfg.demean         = 'yes';
% cfg.detrend        = 'yes';
% 
% GRAND_AVERAGE_FINAL_ERP_CONT = ft_timelockgrandaverage(cfg, GRAND_AVERAGE_ERP_SinSal_CONT{:});