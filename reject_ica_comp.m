%% cargar data
path        = 'E:\DatosPsiquiatrico\Procesados\RS3\';
file        = filenames{128};
data        = load([path,file]);
comp        = data.comp;

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
% cfg.compscale  = 'global'; %'local'

ft_databrowser(cfg,comp);
sprintf('%s', file)