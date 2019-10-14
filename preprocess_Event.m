test = ['STB\' 'MMN\' 'BDF\' 'MVD\'];
path = 'E:\DatosPsiquiatrico\';
path_channel = 'E:\DatosPsiquiatrico\canales.ced';
path_save = 'E:\DatosPsiquiatrico\Procesados\';
% t_vent = 90;
event_number = '';

% definir epocas (elegir un pre y un post el trigger)
% linea de base del anterior, ejemplo -300 a -200 (no tan cerca del
% trigger)

for k=1:1%length(test)
    file_list = dir([path, test(k), '*.bdf']);
    filenames = cell(1,length(file_list));
    for i=1:1%length(file_list)
        filenames{i} = file_list(i).name;       
    end

    for i=1:1%length(filenames)
        file = filenames{i};
        EEG = pop_biosig([path, test(k), file]); % abrir archivo

        %% localizar canales
        EEG = pop_chanedit(EEG, 'lookup', path_channel);

        %% Aplicar filtro pasabanda
        EEG = pop_eegfiltnew(EEG, 'locutoff', 0.05, 'hicutoff', 50, 'plotfreqz', 0);
        
        %% Descomposicion ICA
        EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','off');
        
        %% Rechazar componentes
        EEG = interface_ADJ(EEG,'report.txt');
        close all

        rep_id = fopen('report.txt');
        rep = textscan(rep_id, '%s', 'delimiter', '\t', 'collectoutput',true);

        fclose(rep_id);

        clear rep_id

        comp = rep{1, 1}{end}; %obtiene ultima linea del archivo
        index = [1,strfind(comp,'  ')];

        componente = [];
        for j = 2:length(index)
            componente(end+1) = str2double(comp(index(j-1):index(j)));
        end 

        % remover NaN posibles
        rem_nan = @(x)(x(~isnan(x)));
        componente = rem_nan(componente);

        EEG = pop_subcomp(EEG, componente, 0); % elimina componentes

        %% Downsampling a 256 Hz (no menor a 1.5 del tamanho senhal)
        EEG = pop_resample(EEG, 256); % 512

        %% Corregir linea base (promedio)
        % extraer epocas segun el evento que quiero
        EEG = pop_epoch(EEG, {event_number}, [-0.3 1]);
        EEG = pop_rmbase(EEG, [-200 0], []);

        %% re-referenciar a cz (mas usado)
        EEG = pop_reref(EEG, 48);

        %% guardar datos
        data = EEG.data;
        
        % FIELDTRIP (conectividad) 
        % DESCOMPOSICION DE LA SEÑAL (TIME FRECUENCY) Y LUEGO CALCULAR
        % CONECTIVIDAD
        % O SACAR ERP (PROMEDIAR LOS TRIAL DE CADA SEÑAL => 64 ELECTRODOS
        % => 64 POSIBLES ERP, decidir si sacar zonas de interes o no)
        % Determinar medida de conectividad (coh, wpli, plv)
        
        % DEL ERP SE PUEDE MEDIR EL PIC, AREA, AMPLITUD, PICK TO PICK,
        % LATENCIA
        
        save([path_save, test(k), file], 'data');

        close all;
    end
end