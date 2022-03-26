%%%%%% calculo de conectividad

%% cargar data preprocesada en EEGLAB
path = '...';
file = '...';
data = load([path,file]);
data = data.DATA_REJECT;

cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 2;
freq          = ft_freqanalysis(cfg, data); % VER COMO REMOVER TRIALINFO

%% Computation and inspection of the connectivity measures
 
cfg           = [];
cfg.method    = 'coh';
coh           = ft_connectivityanalysis(cfg, freq); %% muestra la conectividad de un electrodo con otro para una cierta frecuencia, la diagonal es 1 => 100% conectividad, mientras mas cerca de 1 => mas conectado estas
coh_freq = coh.freq;
coh_conectivity = coh.cohspctrm;

save([path, file(1:8), '_CONECT_COH.mat'],'coh')
save([path, file(1:8), '_CONECT_COH_FREQ.mat'],'coh_freq') % MAS IMPORTANTE PARA TRABAJAR
save([path, file(1:8), '_CONECT_COH_TENSOR_CONECTIVIDAD.mat'],'coh_conectivity')
