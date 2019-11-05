path = 'E:\DatosPsiquiatrico\MVD\';
path_save = 'E:\DatosPsiquiatrico\Procesados\MVD\';

file_list = dir([path, '*.bdf']);
filenames = cell(1,length(file_list));

for i=29:length(file_list)
    filenames{i-28} = file_list(i).name;       
end

% VER FEP_004 Y FEP_004_BASAL PARA STB
% CNTF_001 STB ESTA ENTRE -0.2 Y 0.8

% events = [91 92 101 102]; % STB (cuando responde)
% events = [1 2 3 10 11 12]; % DF (cuando responde)
% events = 70; % MMN Emocional (cuando aparece estimulo infrecuente) SON
% MUCHAS PARTES, VER COMO TRABAJAR (59)
events = [25 35 40 55]; % MD (cuando se muestra cada imagen) (29)
for i=1:length(file_list)
    name = filenames{i};
    file = [path, name];

    %% PREPROC FIELDTRIP (x cada trial que yo quiera sacar o todos)

    cfg                     = [];
    cfg.dataset             = file;
    cfg.trialdef.eventtype  = 'STATUS'; % que era ?
    cfg.trialdef.eventvalue = events;
    % con 0.3 y 1 hay overlap
    cfg.trialdef.prestim    = 0.3;
    cfg.trialdef.poststim   = 1;
    cfg                     = ft_definetrial(cfg);

    %% PREPROCESSING             
    cfg.continuous      = 'no';
    cfg.trials          = 'all';
    cfg.channel         = 'all';
    cfg.bpfilter        = 'yes';
    cfg.bpfreq          = [0.1 100]; % VER ESTO
    cfg.bpfiltord       = 2;
    cfg.bpfilttype      = 'but';
    cfg.demean          = 'yes';
    cfg.detrend         = 'yes';
    cfg.dftfilter       = 'yes'; %Remueve 50 HZ

    % Re-referencing options - see explanation below

    cfg.reref         = 'yes';
    cfg.refchannel    = 1:64;
    cfg.layout        = 'biosemi64.lay';

    DATAEEG  = ft_preprocessing(cfg);
    save([path_save, name(1:end-4), '_FIRST_STEP.mat'],'DATAEEG');
    sprintf('Procesado %s', name)
end