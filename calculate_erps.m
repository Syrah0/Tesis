%%%%%%%%%%%%% calcular ERP

%% Cargar data
path = 'E:\DatosPsiquiatrico\Procesados\STB\';
correct_path = 'E:\DatosPsiquiatrico\Procesados\DatosCorrectos\STB\';
%file = 'CNTF_009_DBF_R1__FINISH.mat';

file_list = dir([path, '*_FINISH.mat']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i-0} = file_list(i).name;       
end

ids  = [91 92 101 102];

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
        % cfg.detrend  = 'yes';

        data = ft_preprocessing(cfg, data);
        
        %% Calculate ERP
        erps = ft_timelockanalysis(cfg, data); %% calcula ERP

        %%%% The most important field is data_time.avg, containing the average over all trials for each sensor.

        %% correccion de linea base --> el promedio lo corrigen
        cfg          = [];
        % VER ESTA LINEA BASE SI LA TOMO DESDE EL INICIO O POCO DESPUES
        cfg.baseline = [-0.3 -0.1]; % no usar linea base en el cero
        timelock     = ft_timelockbaseline(cfg, erps);
        %%%timelock_CROM_PAT = timelock; %Cambia categoria y sujetos que se
        %%%analiza?
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