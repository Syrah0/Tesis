path = 'E:\DatosPsiquiatrico\RS\';
%file = 'CNTF_0001.bdf';
path_save = 'E:\DatosPsiquiatrico\Procesados\RS3\';
file_list = dir([path,'*.bdf']);
t_vent = 90; % me quedo con 90 seg de cada señal, la cual debiese tener un max de 2 min (120 seg) aprox


filenames = cell(1,length(file_list));
for i=89:length(file_list)
    filenames{i-88} = file_list(i).name;       
end


for i=1:length(filenames)
    file = filenames{i}
    
    if ~isempty(strfind(file, 'R1'))
        file_open_eyes = strrep(file, 'bdf', 'mat');
        file_close_eyes = strrep(file_open_eyes, 'R1', 'R2');
        
        % open eeg open eyes
        cfg = [];
        cfg.datafile = [path, file];
        data_open_eyes = ft_preprocessing(cfg);
        
        % open eeg close eyes
        cfg = [];
        cfg.datafile = [path, strrep(file, 'R1', 'R2')];
        data_close_eyes = ft_preprocessing(cfg);
        
    elseif ~isempty(strfind(file, 'R2'))
        continue
        
    else
        file_open_eyes = strcat(file(1:end-4), '_R1.mat');
        file_close_eyes = strrep(file_open_eyes, 'R1', 'R2');
    
        % open eeg with both events        
        cfg = [];
        cfg.datafile = [path,file];
        data = ft_preprocessing(cfg); % para obtener EEG original y sus datos para luego dividirla

        min_time = min(cellfun(@min, data.time)); % obtengo tiempo minimo de la señal original
        max_time = max(cellfun(@max, data.time)); % obtengo tiempo maximo de la señal original
        % ese es el rango de tiempo en el cual se mueve la señal

        % divido la señal en dos partes iguales, una para open eyes y otra para
        % close eyes
        tmax = max_time/2;
        cfg = [];
        cfg.toilim = [min_time tmax]; % este es para open
        data_open_eyes = ft_redefinetrial(cfg,data);

        cfg = [];
        cfg.toilim = [tmax max_time]; % este es para close
        data_close_eyes = ft_redefinetrial(cfg,data);
    end

    % saco los extremos de la data para quedarme con la data mas probable a ser
    % open y close eyes

    max_eeg_open_eyes = max(cellfun(@max, data_open_eyes.time));
    min_eeg_open_eyes = min(cellfun(@min, data_open_eyes.time));
    max_eeg_close_eyes = max(cellfun(@max, data_close_eyes.time));
    min_eeg_close_eyes = min(cellfun(@min, data_close_eyes.time));

    tau_open_eyes = ((max_eeg_open_eyes - min_eeg_open_eyes) - t_vent)/2;
    tau_close_eyes = ((max_eeg_close_eyes - min_eeg_close_eyes) - t_vent)/2;

    cfg = [];
    cfg.toilim = [tau_open_eyes max_eeg_open_eyes-tau_open_eyes];
    data_open_eyes = ft_redefinetrial(cfg,data_open_eyes); % open eyes

    cfg = [];
    cfg.toilim = [min_eeg_close_eyes+tau_close_eyes max_eeg_close_eyes-tau_close_eyes];
    data_close_eyes = ft_redefinetrial(cfg,data_close_eyes); % close eyes
    
    %% APLICAR FILTRO A 50 HZ (lo mas probable otro preprocesing que puede ir aca mismo)

    % data close eyes
    cfg = [];
    cfg.continuous      = 'no';
    cfg.trials          = 'all';
    cfg.channel         = 'all';
    cfg.bpfilter        = 'yes'; % SE APLICA EL FILTRO PASABANDA
    cfg.bpfreq          = [0.1 100]; % VER ESTO, REMUEVE LOS HZ CHICOS
    cfg.bpfiltord       = 2;
    cfg.bpfilttype      = 'but';
    cfg.demean          = 'yes';
    cfg.detrend         = 'yes';
    cfg.dftfilter       = 'yes'; %Remueve 50 HZ PARA ARRIBA ?

    % Re-referencing options - see explanation below

    cfg.reref         = 'yes';
    cfg.refchannel    = 1:64;
    cfg.layout        = 'biosemi64.lay';

    DATAEEGOPEN  = ft_preprocessing(cfg, data_open_eyes);
    save([path_save, file_open_eyes],'DATAEEGOPEN');
    
    % data close eyes
    cfg = [];
    cfg.continuous      = 'no';
    cfg.trials          = 'all';
    cfg.channel         = 'all';
    cfg.bpfilter        = 'yes'; % SE APLICA EL FILTRO PASABANDA
    cfg.bpfreq          = [0.1 100]; % VER ESTO, REMUEVE LOS HZ CHICOS
    cfg.bpfiltord       = 2;
    cfg.bpfilttype      = 'but';
    cfg.demean          = 'yes';
    cfg.detrend         = 'yes'; %QUE HACE??
    cfg.dftfilter       = 'yes'; %Remueve 50 HZ PARA ARRIBA ?

    % Re-referencing options - see explanation below

    cfg.reref         = 'yes';
    cfg.refchannel    = 1:64;
    cfg.layout        = 'biosemi64.lay';

    DATAEEGCLOSE  = ft_preprocessing(cfg, data_close_eyes);
    save([path_save, file_close_eyes],'DATAEEGCLOSE');

    % data_r2_1.trial{1,1} esta el EEG

    %% DESPUES DE ESO VIENE EL PROCESAMIENTO MANUAL DE LA SEÑAL PERO HAY QUE CAMBIARLA PARA RS
end