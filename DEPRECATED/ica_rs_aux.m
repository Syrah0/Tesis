path        = 'E:\DatosPsiquiatrico\Procesados\RS3\nuevos\paso2\';
file_list = dir([path, '*.mat']);
filenames = cell(1,length(file_list));

for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
end

for i=7:length(file_list)
    file        = filenames{i};
    fprintf('abriendo %s\n', file);
    data        = load([path,file]);
    comp        = data.comp;

    %% Rechazo de componentes
        
    figure
    cfg           = [];
    cfg.component = 1:20;       % specify the component(s) that should be plotted
    cfg.layout    = 'biosemi64.lay'; % specify the layout file that should be used for plotting
    cfg.comment   = 'no';

    ft_topoplotIC(cfg, comp);% FT_TOPOPLOTIC plots the topographic distribution of an independent
    
    fprintf('cerrando %s\n', file);
    input('');
end

fprintf('FINAL \n');