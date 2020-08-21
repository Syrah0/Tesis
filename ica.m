%% cargar data
path        = 'E:\DatosPsiquiatrico\Procesados\DBF\';
file        = 'FEP_0005_DBF_R1_REJECT_COMP.mat';
data        = load([path,file]);
DATAEEG_CAT = data.REJECT_COMP;

%% downsamplig --> ICA --> RECHAZO VISUAL
cfg            = [];
cfg.resamplefs = 256;
cfg.detrend    = 'no';

RESAM = ft_resampledata(cfg, DATAEEG_CAT); %Cambiar fin de extension
        
cfg         = [];
cfg.method  = 'runica';
% cfg.demean  = 'yes';
cfg.channel = 1:64; %<=>{'all', '-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8', '-Status', '-refchan'};
% indico el rank de mi conjunto de datos explicitamente
cfg.runica.pca = 64; % ESTO ARREGLO ICA, INDICAR EXPLICITAMENTE LA CANTIDAD DE CANALES INDEPENDIENTES!!!
comp        = ft_componentanalysis(cfg, RESAM);
       
save([path, file(1:end-15), '_ICA_FIX.mat'],'comp') ;
'guardado'
        
% 
% %% Rechazo de componentes
%         
% figure
% cfg           = [];
% cfg.component = 1:20;       % specify the component(s) that should be plotted
% cfg.layout    = 'biosemi64.lay'; % specify the layout file that should be used for plotting
% cfg.comment   = 'no';
% 
% ft_topoplotIC(cfg, comp);% FT_TOPOPLOTIC plots the topographic distribution of an independent
% 
% %component that was computed using the FT_COMPONENTANALYSIS function
% 
% %% Señal con componentes
% 
% cfg            = [];
% cfg.viewmode   = 'component';
% cfg.layout     = 'biosemi64.lay'; % specify the layout file that should be used for plotting
% cfg.continuous = 'no';
% cfg.channel    = 1:30;
% cfg.compscale  = 'global'; %'local'
% 
% ft_databrowser(cfg,comp);
% 
% cfg            = [];
% cfg.viewmode   = 'component';
% cfg.layout     = 'biosemi64.lay'; % specify the layout file that should be used for plotting
% cfg.continuous = 'no';
% cfg.channel    = 1:30;
% cfg.compscale  = 'local'; %'local'
% 
% ft_databrowser(cfg,comp);
% 
% 
% %% Para ver componentes de la señal antes de rechazar componentes
% 
% cfg            = [];
% cfg.continuous = 'no';
% cfg.channel    = 'all';
% cfg.viewmode   = 'vertical';%'butterfly'
% cfg.compscale  = 'global'; %'local'
% 
% ft_databrowser(cfg,comp); 