%% cargar data
path        = 'E:\DatosPsiquiatrico\Procesados\STB\';
file        = 'CNTF_001_REJECT_COMP.mat';
data        = load([path,file]);
DATAEEG_CAT = data.REJECT_COMP2;%dataFIC;

%% downsamplig --> ICA --> RECHAZO VISUAL
cfg            = [];
cfg.resamplefs = 256;
cfg.detrend    = 'no';

RESAM = ft_resampledata(cfg, DATAEEG_CAT); %Cambiar fin de extension
        
cfg         = [];
cfg.method  = 'runica';
cfg.demean  = 'yes';
cfg.channel = 1:64;
comp        = ft_componentanalysis(cfg, RESAM);
       
save([path, file(1:end-15), '_ICA_FIX.mat'],'comp') ;
        
%% Rechazo de componentes
        
figure
cfg           = [];
cfg.component = 1:20;       % specify the component(s) that should be plotted
cfg.layout    = 'biosemi64.lay'; % specify the layout file that should be used for plotting
cfg.comment   = 'no';

ft_topoplotIC(cfg, comp);% FT_TOPOPLOTIC plots the topographic distribution of an independent

%component that was computed using the FT_COMPONENTANALYSIS function

%% Señal con componentes

cfg            = [];
cfg.viewmode   = 'component';
cfg.layout     = 'biosemi64.lay'; % specify the layout file that should be used for plotting
cfg.continuous = 'no';
cfg.channel    = 1:30;
cfg.compscale  = 'global'; %'local'

ft_databrowser(cfg,comp);

%% Para ver componentes de la señal antes de rechazar componentes

cfg            = [];
cfg.continuous = 'no';
cfg.channel    = 'all';
cfg.viewmode   = 'vertical';%'butterfly'
cfg.compscale  = 'global'; %'local'

ft_databrowser(cfg,comp); 