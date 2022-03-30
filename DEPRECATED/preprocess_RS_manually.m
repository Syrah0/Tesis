path = '...';
path_channel = '...';
path_save = 'E...';
file_list = dir([path,'*.bdf']);
t_vent = 90;

filenames = cell(1,length(file_list));
for i=1:length(file_list)
    filenames{i} = file_list(i).name;       
end

for i=1:length(filenames)
    file = filenames{i}
    
    %% separar la data en 2 (ojos abiertos y ojos cerrados)
    if ~isempty(strfind(file, 'R1')) 
        file_open_eyes = file;
        file_close_eyes = strrep(file,'R1','R2');
        
        EEG_open_eyes = pop_biosig([path,file_open_eyes]);
        EEG_close_eyes = pop_biosig([path,file_close_eyes]);
        
    elseif ~isempty(strfind(file, 'R2'))
        return
    
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
    
    % muscular F-T (sacar trozos de la se�al). Solo si esta muy marcado        
    
    %% Downsampling a 256 Hz (no menor a 1.5 del tamanho senhal)
    EEG_open_eyes = pop_resample(EEG_open_eyes, 256);
    EEG_close_eyes = pop_resample(EEG_close_eyes, 256);
    
    %% Corregir linea base (promedio)
    EEG_open_eyes = pop_rmbase(EEG_open_eyes, [], []);
    EEG_close_eyes = pop_rmbase(EEG_close_eyes, [], []);
    
    %% Descomposicion ICA
    EEG_open_eyes = pop_runica(EEG_open_eyes, 'icatype', 'runica', 'extended',1,'interrupt','off');
    EEG_close_eyes = pop_runica(EEG_close_eyes, 'icatype', 'runica', 'extended',1,'interrupt','off');
    
    % sacar pestanheo - sacada (Esto saca componentes pero no pierde
    % informacion de la senhal (senhal cuadrara = sacada (azul-rojo frontal), pestanheo = rojo frontal)
    % no mas de 3 componentes
    
    %% Sacar componentes
    EEG_open_eyes = pop_selectcomps(EEG_open_eyes);
    EEG_close_eyes = pop_selectcomps(EEG_close_eyes);
    
%end
EEG = pop_select( EEG, 'nochannel',{'EXG1' 'EXG2' 'EXG3' 'EXG4' 'EXG5' 'EXG6' 'EXG7' 'EXG8'});
EEG = pop_reref( EEG, []);
EEG = pop_saveset( EEG, 'filename','FEP_001.set','filepath','E:\\DatosPsiquiatrico\\Procesados\\STB\\');
% EEG = pop_reref(EEG, 48);
%data = EEG.data;
%save([path_save, file], 'data');