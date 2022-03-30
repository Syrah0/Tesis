%%%%%%%%%%%%% calcular ERP

%% Cargar data
path = '...';
correct_path = '...';

file_list = dir([path, '*_FINISH.mat']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
end

ids  = []; # event types

for j=1:length(file_list)
    file = filenames{j};
    data = load([path,file]);
    data = data.DATA_REJECT;
    sprintf('%i. Procesando %s', j, file)
    for i=1:length(ids)
        ID             = ids(i); % event
        sprintf('Procesando ERP %i', ID)
        
        %% Elegir trial y hacer filtro pasa bajo a 40
        cfg            = [];
        cfg.trial      = find(data.trialinfo(:,1)==ID); % por cada eventtype
        cfg.lpfilter   = 'yes';
        cfg.lpfreq     = 40;
        cfg.keeptrials = 'no';
        data = ft_preprocessing(cfg, data);
        
        %% Calculate ERP
        erps = ft_timelockanalysis(cfg, data); %% calcula ERP

        %%%% The most important field is data_time.avg, containing the average over all trials for each sensor.

        %% correccion de linea base --> el promedio lo corrigen
        cfg          = [];
        cfg.baseline = [-0.3 0];
        timelock     = ft_timelockbaseline(cfg, erps);
        
        avg = timelock.avg;
        times = timelock.time;

        name_timelock = sprintf('_ERP_%i', ID);
        name_avg = sprintf('_ERP_%i_AVG', ID);
        name_time = sprintf('_ERP_%i_TIME', ID);
        
        save([path, strrep(file, '_FINISH', name_timelock)],'timelock')
        save([path, strrep(file, '_FINISH', name_avg)],'avg') % MAS IMPORTANTE PARA TRABAJAR
        save([path, strrep(file, '_FINISH', name_time)],'times')
        
        save([correct_path, strrep(file, '_FINISH', name_avg)],'avg') % MAS IMPORTANTE PARA TRABAJAR

        sprintf('ERP %i terminado', ID)
    end
    sprintf('%s terminado', file)
end
