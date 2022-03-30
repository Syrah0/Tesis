path = 'E:\DatosPsiquiatrico\RS\';
path_channel = 'E:\DatosPsiquiatrico\canales.ced';
path_save = 'E:\DatosPsiquiatrico\Procesados\RS\';
file_list = dir([path,'*.bdf']);
t_vent = 90;

filenames = cell(1,length(file_list));
for i=106:length(file_list)
    filenames{i-105} = file_list(i).name;       
end

for i=1:length(filenames)
    file = filenames{i};
    
    %% separar la data en 2 (ojos abiertos y ojos cerrados)
    if ~isempty(strfind(file, 'R1')) 
        file_open_eyes = file;
        file_close_eyes = strrep(file,'R1','R2');
        
        EEG_open_eyes = pop_biosig([path,file_open_eyes]);
        EEG_close_eyes = pop_biosig([path,file_close_eyes]);
        
    elseif ~isempty(strfind(file, 'R2'))
        continue
    
    else
        file_open_eyes = strcat(file(1:end-4),'_R1.bdf');
        file_close_eyes = strrep(file_open_eyes,'R1','R2');
        
        EEG = pop_biosig([path,file]);
        
        % acortar a la mitad
        EEG_open_eyes = pop_select(EEG, 'time', [0, EEG.xmax/2]);
        EEG_close_eyes = pop_select(EEG, 'time', [EEG.xmax/2, EEG.xmax]);
        
        clear EEG;
    end
    
    %% cortar extremos
    % definicion del tau
    tau_open_eyes = (EEG_open_eyes.xmax - t_vent)/2;
    tau_close_eyes = (EEG_close_eyes.xmax - t_vent)/2;
    
    % sacar informacion central
    EEG_open_eyes = pop_select(EEG_open_eyes, 'time', [tau_open_eyes, EEG_open_eyes.xmax - tau_open_eyes]);
    EEG_close_eyes = pop_select(EEG_close_eyes, 'time', [tau_close_eyes, EEG_close_eyes.xmax - tau_close_eyes]);
    
    %% localizar canales
    EEG_open_eyes = pop_chanedit(EEG_open_eyes, 'lookup', path_channel);
    EEG_close_eyes = pop_chanedit(EEG_close_eyes, 'lookup', path_channel);
    
    %% Aplicar filtro pasabanda
    EEG_open_eyes = pop_eegfiltnew(EEG_open_eyes, 'locutoff', 0.05, 'hicutoff', 50, 'plotfreqz', 0);
    EEG_close_eyes = pop_eegfiltnew(EEG_close_eyes, 'locutoff', 0.05, 'hicutoff', 50, 'plotfreqz', 0);
    
    % muscular F-T (sacar trozos de la señal). Solo si esta muy marcado        
    
    %% Descomposicion ICA
    EEG_open_eyes = pop_runica(EEG_open_eyes, 'icatype', 'runica', 'extended',1,'interrupt','off');
    EEG_close_eyes = pop_runica(EEG_close_eyes, 'icatype', 'runica', 'extended',1,'interrupt','off');
    
    % sacar pestañeo - sacada (Esto saca componentes pero no pierde
    % informacion de la señal (señal cuadrara = sacada (azul-rojo frontal), pestañeo = rojo frontal)
    % no mas de 3 componentes
    
    %% Rechazar componentes
    EEG_open_eyes = interface_ADJ(EEG_open_eyes,'report_open_eyes.txt');
    EEG_close_eyes = interface_ADJ(EEG_close_eyes,'report_close_eyes.txt');
    close all
    
    rep_open_eyes_id = fopen('report_open_eyes.txt');
    rep_close_eyes_id = fopen('report_close_eyes.txt');
    rep_open_eyes = textscan(rep_open_eyes_id, '%s', 'delimiter', '\t', 'collectoutput',true);
    rep_close_eyes = textscan(rep_close_eyes_id, '%s', 'delimiter', '\t', 'collectoutput',true);
    
    fclose(rep_open_eyes_id);
    fclose(rep_close_eyes_id);
    
    clear rep_open_eyes_id rep_close_eyes_id
    
    comp_open_eyes = rep_open_eyes{1, 1}{end}; %obtiene ultima linea del archivo
    comp_close_eyes = rep_close_eyes{1, 1}{end};
    index_open_eyes = [1,strfind(comp_open_eyes,'  ')];
    index_close_eyes = [1,strfind(comp_close_eyes,'  ')];
    
    componente_open_eyes = [];
    for j = 2:length(index_open_eyes)
        componente_open_eyes(end+1) = str2double(comp_open_eyes(index_open_eyes(j-1):index_open_eyes(j)));
    end 
    
    componente_close_eyes = [];
    for j = 2:length(index_close_eyes)
        componente_close_eyes(end+1) = str2double(comp_close_eyes(index_close_eyes(j-1):index_close_eyes(j)));
    end
    
    % remover NaN posibles
    rem_nan = @(x)(x(~isnan(x)));
    componente_open_eyes = rem_nan(componente_open_eyes);
    componente_close_eyes = rem_nan(componente_close_eyes);
    
    EEG_open_eyes = pop_subcomp(EEG_open_eyes, componente_open_eyes, 0);
    EEG_close_eyes = pop_subcomp(EEG_close_eyes, componente_close_eyes, 0);
    
    %% Downsampling a 256 Hz (no menor a 1.5 del tamanho senhal)
    EEG_open_eyes = pop_resample(EEG_open_eyes, 256);
    EEG_close_eyes = pop_resample(EEG_close_eyes, 256);
    
    %% Corregir linea base (promedio)
    EEG_open_eyes = pop_rmbase(EEG_open_eyes, [], []);
    EEG_close_eyes = pop_rmbase(EEG_close_eyes, [], []);
    
    %% re-referenciar a cz (mas usado)
    EEG_open_eyes = pop_reref(EEG_open_eyes, 48);
    EEG_close_eyes = pop_reref(EEG_close_eyes, 48);
    
    %% guardar datos
    data_open_eyes = EEG_open_eyes.data;
    data_close_eyes = EEG_close_eyes.data;
    
    save([path_save, file_open_eyes], 'data_open_eyes');
    save([path_save, file_close_eyes], 'data_close_eyes');
    
    close all;
end