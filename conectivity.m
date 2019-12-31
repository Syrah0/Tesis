%%%%%% calculo de conectividad

%% cargar data preprocesada en EEGLAB
% data = eeglab2fieldtrip(EEG, 'preprocessing', 'none');   % convert the EEG data structure to fieldtrip
path = 'E:\DatosPsiquiatrico\Procesados\STB\';
file = 'FEP_010__FINISH.mat';
data = load([path,file]);
data = data.DATA_REJECT;

%% correccion de linea base --> el promedio lo corrigen
% cfg          = [];
% cfg.baseline = [-0.2 -0.1]; % no usar linea base en el cero
% data     = ft_timelockbaseline(cfg, data);

%% hacer analisis de time-frecuency
%% Computation of the multivariate autoregressive model

% cfg         = [];
% cfg.order   = 5;
% cfg.toolbox = 'bsmart'; %%bsmart, biosig
% mdata       = ft_mvaranalysis(cfg, data);

%% Computation of the spectral transfer function

% cfg        = [];
% cfg.method = 'mvar';
% mfreq      = ft_freqanalysis(cfg, mdata);

%% OR Non-parametric computation of the cross-spectral density matrix (VER BN)

% Some connectivity metrics can be computed from a non-parametric spectral 
% estimate (i.e. after the application of the FFT-algorithm and conjugate 
% multiplication to get cross-spectral densities), such as coherence, 
% phase-locking value and phase slope index. The following part computes the 
% Fourier-representation of the data using ft_freqanalysis.

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
% cohm          = ft_connectivityanalysis(cfg, mfreq);
coh_freq = coh.freq;
coh_conectivity = coh.cohspctrm;

save([path, file(1:8), '_CONECT_COH.mat'],'coh')
save([path, file(1:8), '_CONECT_COH_FREQ.mat'],'coh_freq')
save([path, file(1:8), '_CONECT_COH_TENSOR_CONECTIVIDAD.mat'],'coh_conectivity')
% save([path, file(1:8), '_CONECT_COHM.mat'],'cohm')