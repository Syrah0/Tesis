%% RECHAZAR COMPONENTES
%% Cargar dato
path        = '...';
file        = 'XXX__ICA_FIX.mat';
data        = load([path,file]);
comp        = data.comp;

file_list = dir([path, '*.mat']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
end

for i=1:length(file_list)
    file        = filenames{i};
    fprintf('abriendo %s\n', file);
    data        = load([path,file]);
    comp        = data.comp;

    %% 2 Rechazar componentes
    icas = input('Componentes a rechazar: ');
    if isempty(icas)
        fprintf('sin rechazo\n');
    else
        fprintf('rechazando: %d\n', icas);
    end
    cfg           = [];
    cfg.component = icas; %  CAMBIA segun el sujeto que se analiza
    DATA_REJECT   = ft_rejectcomponent(cfg,comp);

    %% Guarda el dato analizado

    %DATA_REJECT_SINSAL_PAT = DATA_REJECT;
    save([path_n, file(1:end-12), '_FINISH.mat'],'DATA_REJECT') ; % POST REJECT

    %close all
end
