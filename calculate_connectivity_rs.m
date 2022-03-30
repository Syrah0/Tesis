%%%%%% calculo de conectividad

%% cargar data preprocesada
path = '...';
correct_path = '...'; # where save new data
file_list = dir([path, '*_FINISH.mat']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
end

for j=1:length(file_list)
    file = filenames{j};
    data = load([path,file]);
    data = data.DATA_REJECT;
    sprintf('%i. Procesando %s', j, file)

    cfg.method    = 'mtmfft';
    cfg.taper     = 'dpss';
    cfg.output    = 'fourier';
    cfg.tapsmofrq = 2;
    freq          = ft_freqanalysis(cfg, data);

    %% Computation and inspection of the connectivity measures

    cfg           = [];
    cfg.method    = 'coh';
    coh           = ft_connectivityanalysis(cfg, freq); %% muestra la conectividad de un electrodo con otro para una cierta frecuencia, la diagonal es 1 => 100% conectividad, mientras mas cerca de 1 => mas conectado estas
        
    % coh_freq      = coh.freq;
    coh_connect   = coh.cohspctrm;

    % name_coh = '_CONECT_COH';
    name_freq = '_AVG_CONECT_COH_FREQ';
    % name_tensor = '_TIME_CONECT_COH_TENSOR_CONECTIVIDAD';

    save([correct_path, strrep(file, '_FINISH', name_freq)],'coh_connect') % MAS IMPORTANTE PARA TRABAJAR
    sprintf('%s terminado', file)
end
