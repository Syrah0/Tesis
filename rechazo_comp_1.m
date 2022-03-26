%% RECHAZO ARTEFACTOS (databrowser)

%% cargar data
path    = '...';
file    = '...';
data    = load([path,file]);
dataFIC = data.DATAEEG;

%% Seleccionar artefactos manualmente

% open the browser and page through the trials
cfg              = [];
cfg.viewmode     = 'vertical';
cfg.continuous   = 'no';
cfg.allowoverlap = 'yes';
ft_databrowser(cfg,dataFIC);

cfg            = [];
cfg.method     = 'trial';
cfg.viewmode   = 'summary' ;

REJECT_COMP    = ft_rejectvisual(cfg,dataFIC); %Data EEG es mi dato con la señal

cfg            = [];
cfg.continuous = 'no';
cfg.viewmode   = 'vertical';
cfg.allowoverlap = 'yes';

ft_databrowser(cfg, REJECT_COMP);%Dato con rechazo
