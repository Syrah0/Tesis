%% RECHAZAR COMPONENTES
%% Cargar dato
path        = 'E:\DatosPsiquiatrico\Procesados\STB\';
file        = 'CNTF_001_ICA_FIX.mat';
data        = load([path,file]);
comp        = data.comp;

%% 2 Rechazar componentes

cfg           = [];
cfg.component = []; %  CAMBIA según el sujeto que se analiza
DATA_REJECT   = ft_rejectcomponent(cfg,comp);

%% Para ver como quedó la señal

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