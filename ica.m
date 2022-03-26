%% cargar data
path        = '...';
file        = '...';
data        = load([path,file]);
DATAEEG_CAT = data.REJECT_COMP;

%% downsamplig --> ICA --> RECHAZO VISUAL
cfg            = [];
cfg.resamplefs = 256;
cfg.detrend    = 'no';

RESAM = ft_resampledata(cfg, DATAEEG_CAT); %Cambiar fin de extension
        
cfg         = [];
cfg.method  = 'runica';
cfg.channel = 1:64; %<=>{'all', '-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8', '-Status', '-refchan'};
% indico el rank de mi conjunto de datos explicitamente
cfg.runica.pca = 64; % ESTO ARREGLO ICA, INDICAR EXPLICITAMENTE LA CANTIDAD DE CANALES INDEPENDIENTES!!!
comp        = ft_componentanalysis(cfg, RESAM);
       
save([path, file(1:end-15), '_ICA_FIX.mat'],'comp') ;
