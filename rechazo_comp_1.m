%% RECHAZO ARTEFACTOS (databrowser)
%%%% problema!!!! D:

%% cargar data
path    = 'E:\DatosPsiquiatrico\Procesados\STB\';
file    = 'CNTF_001_FIRST_STEP.mat';
data    = load([path,file]);
dataFIC = data.DATAEEG;

%% Seleccionar artefactos manualmente

% first select only the EEG channels
% cfg         = [];
% cfg.channel = 'EEG';
% data        = ft_preprocessing(cfg,dataFIC);

% open the browser and page through the trials
cfg              = [];
% cfg.channel      = 'EEG';
cfg.viewmode     = 'vertical';
cfg.continuous   = 'no';
cfg.allowoverlap = 'yes';
ft_databrowser(cfg,dataFIC);
% cfg              = ft_databrowser(cfg,dataFIC);

% ft_preprocessing(cfg, dataFIC);
% ft_rejectartifact(cfg, dataFIC);

% save([path, file(1:end-15), '_REJECT_COMP.mat'],'dataFIC') ; % POST
% REJECT

cfg            = [];
cfg.method     = 'trial';
cfg.viewmode   = 'summary' ;

REJECT_COMP    = ft_rejectvisual(cfg,dataFIC); %Data EEG es mi dato con la señal

cfg            = [];
cfg.continuous = 'no';
cfg.viewmode   = 'vertical';
cfg.allowoverlap = 'yes';

ft_databrowser(cfg, REJECT_COMP);%Dato con rechazo

% save([path, file(1:end-15), '_REJECT_COMP.mat'],'REJECT_COMP') ; % POST