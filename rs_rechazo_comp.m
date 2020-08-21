%% HACER INSPECCION MANUAL DE LAS VENTANAS (rechazo_comp_1)

%% RECHAZO ARTEFACTOS (databrowser)

%% cargar data
path    = 'E:\DatosPsiquiatrico\Procesados\RS3\';
file_list = dir([path,'*.mat']);

filenames = cell(1,length(file_list));
for i=245:length(file_list)
    filenames{i-244} = file_list(i).name;       
end

for i=1:length(filenames)
    file    = filenames{i};
    fprintf('abriendo %s\n', file);
    data    = load([path,file]);

    if ~isempty(strfind(file, 'R1'))
        dataFIC = data.DATAEEGOPEN;
    else
        dataFIC = data.DATAEEGCLOSE;
    end


    %% Seleccionar artefactos manualmente

    % first select only the EEG channels
    % cfg         = [];
    % cfg.channel = 'EEG';
    % data        = ft_preprocessing(cfg,dataFIC);

    % divido la señal completa en mini trials de 2 seg (considerar que la señal
    % debiese tener 90 seg => debiesen dar 45 trials
    delta = 2; % divido en varios trials de 2 seg cada uno

    cfg = [];
    cfg.length = delta;
    dataFIC = ft_redefinetrial(cfg,dataFIC);

    % open the browser and page through the trials
    cfg              = [];
    % cfg.channel      = 'EEG';
    cfg.viewmode     = 'vertical';
    cfg.continuous   = 'no';
    cfg.allowoverlap = 'yes';
    ft_databrowser(cfg,dataFIC);

    % REJECT

    cfg            = [];
    cfg.method     = 'trial';
    cfg.viewmode   = 'summary' ;

    REJECT_COMP    = ft_rejectvisual(cfg,dataFIC); %Data EEG es mi dato con la señal

    cfg            = [];
    cfg.continuous = 'no';
    cfg.viewmode   = 'vertical';
    cfg.allowoverlap = 'yes';

    ft_databrowser(cfg, REJECT_COMP);%Dato con rechazo

    save([path, file(1:end-4), '_REJECT_COMP.mat'],'REJECT_COMP'); % POST
    fprintf('guardado %s\n', file(1:end-4));
end

%% Downsampling a 256 Hz (no menor a 1.5 del tamanho senhal) (ica.m)

%% Descomposicion ICA (ica.m)

%% Rechazo comp ica (ica2.m)

%% PROMEDIAR TRIALS PARA VOLVER A JUNTARLOS ANTES DE CALCULAR CONECTIVIDAD

%% correccion de linea base --> el promedio lo corrigen (conectivity.m)

%% calculo de la conectividad (conectivity.m)