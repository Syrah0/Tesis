%% cargar data
path    = '...';
file_list = dir([path,'*.mat']);

filenames = cell(1,length(file_list));
for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
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
    
    % divido la señal completa en mini trials de 2 seg (considerar que la señal
    % debiese tener 90 seg => debiesen dar 45 trials
    delta = 1.3; % divido en varios trials de 2 seg cada uno

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

    save([path_n, file(1:end-4), '_REJECT_COMP.mat'],'REJECT_COMP'); % POST
    fprintf('guardado %s\n', file(1:end-4));
end
