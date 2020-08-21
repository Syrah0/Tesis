%%%%%% calculo de conectividad

%% cargar data preprocesada
path = 'E:\DatosPsiquiatrico\Procesados\STB\';
correct_path = 'E:\DatosPsiquiatrico\Procesados\DatosCorrectos\STB\';
%file = 'CNTF_007_DBF_R1__FINISH.mat';
file_list = dir([path, '*_FINISH.mat']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i-0} = file_list(i).name;       
end

ids = [91 92 101 102];

for j=1:length(file_list)
    file = filenames{j};
    data = load([path,file]);
    data = data.DATA_REJECT;
    sprintf('%i. Procesando %s', j, file)
    for i=1:length(ids)
        ID             = ids(i); % event
        sprintf('Procesando event %i', ID)
        
        %% Elegir trial
        cfg            = [];
        cfg.trial      = find(data.trialinfo(:,1)==ID); % por cada eventtype
        cfg.keeptrials = 'yes';

        data           = ft_preprocessing(cfg, data);
        
        %% hacer analisis de time-frecuency
        %% Computation of the multivariate autoregressive model

        % cfg          = [];
        % cfg.order    = 5;
        % cfg.toolbox  = 'bsmart'; %%bsmart, biosig
        % mdata        = ft_mvaranalysis(cfg, data);

        %% Computation of the spectral transfer function

        % cfg         = [];
        % cfg.method  = 'mvar';
        % mfreq       = ft_freqanalysis(cfg, mdata);

        %% OR Non-parametric computation of the cross-spectral density matrix (VER BN)

        % Some connectivity metrics can be computed from a non-parametric spectral 
        % estimate (i.e. after the application of the FFT-algorithm and conjugate 
        % multiplication to get cross-spectral densities), such as coherence, 
        % phase-locking value and phase slope index. The following part computes the 
        % Fourier-representation of the data using ft_freqanalysis.

        % cfg           = [];
        cfg.method    = 'mtmfft';
        cfg.taper     = 'dpss';
        cfg.output    = 'fourier';
        cfg.tapsmofrq = 2;
        freq          = ft_freqanalysis(cfg, data);

%         %% correccion de linea base --> el promedio lo corrigen
%         cfg              = [];
%         cfg.baseline     = [-0.3 -0.1]; % no usar linea base en el cero
%         cfg.baselinetype = 'relchange';
%         freq_blc         = ft_freqbaseline(cfg, freq);

        %% Computation and inspection of the connectivity measures

        cfg           = [];
        cfg.method    = 'coh';
        coh           = ft_connectivityanalysis(cfg, freq); %% muestra la conectividad de un electrodo con otro para una cierta frecuencia, la diagonal es 1 => 100% conectividad, mientras mas cerca de 1 => mas conectado estas
        % cohm          = ft_connectivityanalysis(cfg, mfreq);
        
        coh_freq      = coh.freq;
        coh_connect   = coh.cohspctrm;

        name_coh = sprintf('_EVENT_%i_CONECT_COH', ID);
        name_freq = sprintf('_EVENT_%i_AVG_CONECT_COH_FREQ', ID);
        name_tensor = sprintf('_EVENT_%i_TIME_CONECT_COH_TENSOR_CONECTIVIDAD', ID);
        
        save([path, strrep(file, '_FINISH', name_coh)],'coh')
        save([path, strrep(file, '_FINISH', name_freq)],'coh_freq')
        save([path, strrep(file, '_FINISH', name_tensor)],'coh_connect')
        % save([path, file(1:8), '_CONECT_COHM.mat'],'cohm')
        
        save([correct_path, strrep(file, '_FINISH', name_freq)],'coh_connect') % MAS IMPORTANTE PARA TRABAJAR
    
        sprintf('Event %i terminado', ID)
    end
    sprintf('%s terminado', file)
end