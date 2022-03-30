path = '...';
path_save = '...';

file_list = dir([path, '*.bdf']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
end

for i=1:length(file_list)
    name = filenames{i};
    file = [path, name];

    %% PREPROC FIELDTRIP (x cada trial que yo quiera sacar o todos)

    cfg                     = [];
    cfg.dataset             = file;
    cfg.trialdef.eventtype  = 'STATUS';
    cfg.trialdef.eventvalue = events;
    cfg.trialdef.prestim    = 0.3;
    cfg.trialdef.poststim   = 1;
    cfg                     = ft_definetrial(cfg);

    %% PREPROCESSING             
    cfg.continuous      = 'no';
    cfg.trials          = 'all';
    cfg.channel         = 'all';
    cfg.bpfilter        = 'yes'; % SE APLICA EL FILTRO PASABANDA (band stop filter)
    cfg.bpfreq          = [0.1 100]; % REMUEVE LOS HZ CHICOS
    cfg.bpfiltord       = 2;
    cfg.bpfilttype      = 'but';
    cfg.demean          = 'yes';
    cfg.detrend         = 'yes';
    cfg.dftfilter       = 'yes'; % Remueve 50 HZ PARA ARRIBA

    % Re-referencing options - see explanation below

    cfg.reref         = 'yes';
    cfg.refchannel    = 1:64;
    cfg.layout        = 'biosemi64.lay';

    DATAEEG  = ft_preprocessing(cfg);
    save([path_save, name(1:end-4), '_FIRST_STEP.mat'],'DATAEEG');
    sprintf('Procesado %s', name)
end