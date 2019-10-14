%% RECHAZO ARTEFACTOS (databrowser)
%%%% problema!!!! D:

%% cargar data
path    = 'E:\DatosPsiquiatrico\Procesados\STB\';
file    = 'CNTF_001_FIRST_STEP.mat';
data    = load([path,file]);
dataFIC = data.DATAEEG;

%% Seleccionar artefactos manualmente

% first select only the EEG channels
cfg         = [];
cfg.channel = 'EEG';
data        = ft_preprocessing(cfg,dataFIC);

% open the browser and page through the trials
cfg         = [];
cfg.channel = 'EEG';
artf        = ft_databrowser(cfg,dataFIC);

% save([path, file(1:end-15), '_REJECT_COMP.mat'],'dataFIC') ; % POST
% REJECT