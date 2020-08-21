%% cargar data
path        = 'E:\DatosPsiquiatrico\Procesados\STB\';
% file        = 'FEP_0005_DBF_R1_REJECT_COMP.mat';
file_list = dir([path, '*_REJECT_COMP.mat']);
filenames = cell(1,length(file_list));

for i=2:length(file_list)
    filenames{i-1} = file_list(i).name;       
end

for i=1:length(file_list)
    file        = filenames{i};
    data        = load([path,file]);
    sprintf('Procesando %s', file)
    DATAEEG_CAT = data.REJECT_COMP;

    %% downsamplig --> ICA --> RECHAZO VISUAL
    cfg            = [];
    cfg.resamplefs = 256;
    cfg.detrend    = 'no';

    RESAM = ft_resampledata(cfg, DATAEEG_CAT); %Cambiar fin de extension

    cfg         = [];
    cfg.method  = 'runica';
    cfg.demean  = 'yes';
    cfg.channel = 1:64; %<=>{'all', '-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8', '-Status', '-refchan'};
    % indico el rank de mi conjunto de datos explicitamente
    cfg.runica.pca = 64; % ESTO ARREGLO ICA, INDICAR EXPLICITAMENTE LA CANTIDAD DE CANALES INDEPENDIENTES!!!
    comp        = ft_componentanalysis(cfg, RESAM);

    save([path, file(1:end-15), '_ICA_FIX.mat'],'comp') ;
    sprintf('Guardado %s', file)
end