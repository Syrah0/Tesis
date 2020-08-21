%% RECHAZAR COMPONENTES
%% Cargar dato
path        = 'E:\DatosPsiquiatrico\Procesados\RS3\';
file        = filenames{128};
data        = load([path,file]);
comp        = data.comp;

%% 2 Rechazar componentes

cfg           = [];
cfg.component = [3,7]; %  CAMBIA seg�n el sujeto que se analiza
DATA_REJECT   = ft_rejectcomponent(cfg,comp);

%% Para ver como qued� la se�al

cfg            = [];
cfg.continuous = 'no';
cfg.channel    = 'all';
cfg.viewmode   = 'vertical';%'butterfly'
cfg.compscale  = 'global'; %'local'
cfg.fontsize   = 8;

ft_databrowser(cfg,DATA_REJECT);
 
%% Guarda el dato analizado

%DATA_REJECT_SINSAL_PAT = DATA_REJECT;
save([path, file(1:end-12), '_FINISH.mat'],'DATA_REJECT') ; % POST REJECT

%close all
sprintf('%s', file)